/*
 * GnuTLS PKCS#11 support
 * Copyright (C) 2010-2014 Free Software Foundation, Inc.
 * Copyright (C) 2012-2015 Nikos Mavrogiannopoulos
 * Copyright (C) 2016-2017 Red Hat, Inc.
 * 
 * Author: Nikos Mavrogiannopoulos
 *
 * The GnuTLS is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2.1 of
 * the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

#include "gnutls_int.h"
#include <gnutls/pkcs11.h>
#include <stdio.h>
#include <string.h>
#include "errors.h"
#include <datum.h>
#include <pkcs11_int.h>
#include <gnutls/abstract.h>
#include <pk.h>
#include <x509_int.h>
#include <tls-sig.h>
#include <algorithms.h>
#include <fips.h>
#include <system-keys.h>
#include "urls.h"
#include "pkcs11_int.h"
#include <abstract_int.h>

static int
privkey_sign_prehashed(gnutls_privkey_t signer,
		       const gnutls_sign_entry_st *se,
		       const gnutls_datum_t * hash_data,
		       gnutls_datum_t * signature,
		       gnutls_x509_spki_st * params, unsigned flags);

/**
 * gnutls_privkey_get_type:
 * @key: should contain a #gnutls_privkey_t type
 *
 * This function will return the type of the private key. This is
 * actually the type of the subsystem used to set this private key.
 *
 * Returns: a member of the #gnutls_privkey_type_t enumeration on
 *   success, or a negative error code on error.
 *
 * Since: 2.12.0
 **/
gnutls_privkey_type_t gnutls_privkey_get_type(gnutls_privkey_t key)
{
	return key->type;
}

/**
 * gnutls_privkey_get_seed:
 * @key: should contain a #gnutls_privkey_t type
 * @digest: if non-NULL it will contain the digest algorithm used for key generation (if applicable)
 * @seed: where seed will be copied to
 * @seed_size: originally holds the size of @seed, will be updated with actual size
 *
 * This function will return the seed that was used to generate the
 * given private key. That function will succeed only if the key was generated
 * as a provable key.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.5.0
 **/
int gnutls_privkey_get_seed(gnutls_privkey_t key, gnutls_digest_algorithm_t *digest, void *seed, size_t *seed_size)
{
	if (key->type != GNUTLS_PRIVKEY_X509)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
	return gnutls_x509_privkey_get_seed(key->key.x509, digest, seed, seed_size);
}

/**
 * gnutls_privkey_verify_seed:
 * @key: should contain a #gnutls_privkey_t type
 * @digest: it contains the digest algorithm used for key generation (if applicable)
 * @seed: the seed of the key to be checked with
 * @seed_size: holds the size of @seed
 *
 * This function will verify that the given private key was generated from
 * the provided seed.
 *
 * Returns: In case of a verification failure %GNUTLS_E_PRIVKEY_VERIFICATION_ERROR
 * is returned, and zero or positive code on success.
 *
 * Since: 3.5.0
 **/
int gnutls_privkey_verify_seed(gnutls_privkey_t key, gnutls_digest_algorithm_t digest, const void *seed, size_t seed_size)
{
	if (key->type != GNUTLS_PRIVKEY_X509)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
	return gnutls_x509_privkey_verify_seed(key->key.x509, digest, seed, seed_size);
}

/**
 * gnutls_privkey_get_pk_algorithm:
 * @key: should contain a #gnutls_privkey_t type
 * @bits: If set will return the number of bits of the parameters (may be NULL)
 *
 * This function will return the public key algorithm of a private
 * key and if possible will return a number of bits that indicates
 * the security parameter of the key.
 *
 * Returns: a member of the #gnutls_pk_algorithm_t enumeration on
 *   success, or a negative error code on error.
 *
 * Since: 2.12.0
 **/
int gnutls_privkey_get_pk_algorithm(gnutls_privkey_t key, unsigned int *bits)
{
	switch (key->type) {
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11:
		return gnutls_pkcs11_privkey_get_pk_algorithm(key->key.pkcs11,
							      bits);
#endif
	case GNUTLS_PRIVKEY_X509:
		if (bits) {
			*bits = pubkey_to_bits(&key->key.x509->params);
		}

		return gnutls_x509_privkey_get_pk_algorithm(key->key.x509);
	case GNUTLS_PRIVKEY_EXT:
		if (bits)
			*bits = 0;
		return key->pk_algorithm;
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

}

static int
privkey_to_pubkey(gnutls_pk_algorithm_t pk,
		  const gnutls_pk_params_st * priv, gnutls_pk_params_st * pub)
{
	int ret;

	pub->algo = priv->algo;
	pub->flags = priv->flags;
	memcpy(&pub->spki, &priv->spki, sizeof(gnutls_x509_spki_st));

	switch (pk) {
	case GNUTLS_PK_RSA_PSS:
	case GNUTLS_PK_RSA:
		pub->params[0] = _gnutls_mpi_copy(priv->params[0]);
		pub->params[1] = _gnutls_mpi_copy(priv->params[1]);

		pub->params_nr = RSA_PUBLIC_PARAMS;

		if (pub->params[0] == NULL || pub->params[1] == NULL) {
			gnutls_assert();
			ret = GNUTLS_E_MEMORY_ERROR;
			goto cleanup;
		}

		break;
	case GNUTLS_PK_DSA:
		pub->params[0] = _gnutls_mpi_copy(priv->params[0]);
		pub->params[1] = _gnutls_mpi_copy(priv->params[1]);
		pub->params[2] = _gnutls_mpi_copy(priv->params[2]);
		pub->params[3] = _gnutls_mpi_copy(priv->params[3]);

		pub->params_nr = DSA_PUBLIC_PARAMS;

		if (pub->params[0] == NULL || pub->params[1] == NULL ||
		    pub->params[2] == NULL || pub->params[3] == NULL) {
			gnutls_assert();
			ret = GNUTLS_E_MEMORY_ERROR;
			goto cleanup;
		}

		break;
	case GNUTLS_PK_ECDSA:
		pub->params[ECC_X] = _gnutls_mpi_copy(priv->params[ECC_X]);
		pub->params[ECC_Y] = _gnutls_mpi_copy(priv->params[ECC_Y]);

		pub->params_nr = ECC_PUBLIC_PARAMS;

		if (pub->params[ECC_X] == NULL || pub->params[ECC_Y] == NULL) {
			gnutls_assert();
			ret = GNUTLS_E_MEMORY_ERROR;
			goto cleanup;
		}

		break;
	case GNUTLS_PK_EDDSA_ED25519:
		ret = _gnutls_set_datum(&pub->raw_pub, priv->raw_pub.data, priv->raw_pub.size);
		if (ret < 0)
			return gnutls_assert_val(ret);

		break;
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

	return 0;
 cleanup:
	gnutls_pk_params_release(pub);
	return ret;
}

/* Returns the public key of the private key (if possible)
 */
int
_gnutls_privkey_get_mpis(gnutls_privkey_t key, gnutls_pk_params_st * params)
{
	int ret;

	switch (key->type) {
	case GNUTLS_PRIVKEY_X509:
		ret = _gnutls_pk_params_copy(params, &key->key.x509->params);
		break;
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11: {
		gnutls_pubkey_t pubkey;

		ret = _pkcs11_privkey_get_pubkey(key->key.pkcs11, &pubkey, 0);
		if (ret < 0)
			return gnutls_assert_val(ret);

		ret = _gnutls_pubkey_get_mpis(pubkey, params);
		gnutls_pubkey_deinit(pubkey);

		break;
		}
#endif
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

	return ret;
}

int
_gnutls_privkey_get_public_mpis(gnutls_privkey_t key,
				gnutls_pk_params_st * params)
{
	int ret;
	gnutls_pk_params_st tmp1;

	gnutls_pk_params_init(&tmp1);

	ret = _gnutls_privkey_get_mpis(key, &tmp1);
	if (ret < 0)
		return gnutls_assert_val(ret);

	ret = privkey_to_pubkey(key->pk_algorithm, &tmp1, params);

	gnutls_pk_params_release(&tmp1);

	if (ret < 0)
		gnutls_assert();

	return ret;
}

/* This function retrieves default sign parameters from KEY. */
int
_gnutls_privkey_get_spki_params(gnutls_privkey_t key,
				gnutls_x509_spki_st * params)
{
	switch (key->type) {
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11:
		break;
#endif
	case GNUTLS_PRIVKEY_EXT:
		break;
	case GNUTLS_PRIVKEY_X509:
		_gnutls_x509_privkey_get_spki_params(key->key.x509, params);
		return 0;
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

	memset(params, 0, sizeof(gnutls_x509_spki_st));

	return 0;
}

/* This function fills in PARAMS with the necessary parameters to sign
 * with PK and DIG. PARAMS must be initialized with
 * _gnutls_privkey_get_spki_params in advance.
 *
 * After calling this function the params structure will
 * be initialized even if the original SubjectPublicKeyInfo was empty.
 */
int
_gnutls_privkey_update_spki_params(gnutls_privkey_t key,
				 gnutls_pk_algorithm_t pk,
				 gnutls_digest_algorithm_t dig,
				 unsigned flags,
				 gnutls_x509_spki_st *params)
{
	unsigned salt_size = 0;
	unsigned bits = 0;
	gnutls_pk_algorithm_t key_pk;

	if (flags & GNUTLS_PRIVKEY_SIGN_FLAG_RSA_PSS) {
		if (!GNUTLS_PK_IS_RSA(pk))
			return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
		pk = GNUTLS_PK_RSA_PSS;
	}

	key_pk = gnutls_privkey_get_pk_algorithm(key, &bits);
	if ((key_pk != pk) &&
	      !(key_pk == GNUTLS_PK_RSA && pk == GNUTLS_PK_RSA_PSS)) {
		gnutls_assert();
		return GNUTLS_E_CONSTRAINT_ERROR;
	}

	if (pk == GNUTLS_PK_RSA_PSS) {
		const mac_entry_st *me;

		me = hash_to_entry(dig);
		if (unlikely(me == NULL))
			return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

		if (params->pk == GNUTLS_PK_RSA)
			salt_size = 0;
		else if (params->pk == GNUTLS_PK_RSA_PSS) {
			if (params->rsa_pss_dig != GNUTLS_DIG_UNKNOWN && dig != params->rsa_pss_dig) {
				return gnutls_assert_val(GNUTLS_E_CONSTRAINT_ERROR);
			}

			salt_size = params->salt_size;
		}

		if (flags & GNUTLS_PRIVKEY_FLAG_REPRODUCIBLE)
			params->salt_size = 0;
		else
			params->salt_size = _gnutls_find_rsa_pss_salt_size(bits, me, salt_size);
		params->rsa_pss_dig = dig;
	}

	params->pk = pk;

	return 0;
}

/**
 * gnutls_privkey_init:
 * @key: A pointer to the type to be initialized
 *
 * This function will initialize a private key object. The object can
 * be used to generate, import, and perform cryptographic operations
 * on the associated private key.
 *
 * Note that when the underlying private key is a PKCS#11 key (i.e.,
 * when imported with a PKCS#11 URI), the limitations of gnutls_pkcs11_privkey_init()
 * apply to this object as well. In versions of GnuTLS later than 3.5.11 the object
 * is protected using locks and a single %gnutls_privkey_t can be re-used
 * by many threads. However, for performance it is recommended to utilize
 * one object per key per thread.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 2.12.0
 **/
int gnutls_privkey_init(gnutls_privkey_t * key)
{
	FAIL_IF_LIB_ERROR;

	*key = gnutls_calloc(1, sizeof(struct gnutls_privkey_st));
	if (*key == NULL) {
		gnutls_assert();
		return GNUTLS_E_MEMORY_ERROR;
	}

	return 0;
}

/**
 * gnutls_privkey_deinit:
 * @key: The key to be deinitialized
 *
 * This function will deinitialize a private key structure.
 *
 * Since: 2.12.0
 **/
void gnutls_privkey_deinit(gnutls_privkey_t key)
{
	if (key == NULL)
		return;

	if (key->flags & GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE
	    || key->flags & GNUTLS_PRIVKEY_IMPORT_COPY)
		switch (key->type) {
#ifdef ENABLE_PKCS11
		case GNUTLS_PRIVKEY_PKCS11:
			gnutls_pkcs11_privkey_deinit(key->key.pkcs11);
			break;
#endif
		case GNUTLS_PRIVKEY_X509:
			gnutls_x509_privkey_deinit(key->key.x509);
			break;
		case GNUTLS_PRIVKEY_EXT:
			if (key->key.ext.deinit_func != NULL)
				key->key.ext.deinit_func(key,
							 key->key.ext.userdata);
			break;
		default:
			break;
		}
	gnutls_free(key);
}

/* Will erase all private key information, except PIN */
void _gnutls_privkey_cleanup(gnutls_privkey_t key)
{
	memset(&key->key, 0, sizeof(key->key));
	key->type = 0;
	key->pk_algorithm = 0;
	key->flags = 0;
}

/* will fail if the private key contains an actual key.
 */
static int check_if_clean(gnutls_privkey_t key)
{
	if (key->type != 0)
		return GNUTLS_E_INVALID_REQUEST;

	return 0;
}

#ifdef ENABLE_PKCS11

/**
 * gnutls_privkey_import_pkcs11:
 * @pkey: The private key
 * @key: The private key to be imported
 * @flags: Flags for the import
 *
 * This function will import the given private key to the abstract
 * #gnutls_privkey_t type.
 *
 * The #gnutls_pkcs11_privkey_t object must not be deallocated
 * during the lifetime of this structure.
 *
 * @flags might be zero or one of %GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE
 * and %GNUTLS_PRIVKEY_IMPORT_COPY.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 2.12.0
 **/
int
gnutls_privkey_import_pkcs11(gnutls_privkey_t pkey,
			     gnutls_pkcs11_privkey_t key, unsigned int flags)
{
	int ret;

	ret = check_if_clean(pkey);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	if (flags & GNUTLS_PRIVKEY_IMPORT_COPY)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	pkey->key.pkcs11 = key;
	pkey->type = GNUTLS_PRIVKEY_PKCS11;
	pkey->pk_algorithm = gnutls_pkcs11_privkey_get_pk_algorithm(key, NULL);
	pkey->flags = flags;

	if (pkey->pin.data)
		gnutls_pkcs11_privkey_set_pin_function(key, pkey->pin.cb,
						       pkey->pin.data);

	return 0;
}

#if 0
/**
 * gnutls_privkey_import_pkcs11_url:
 * @key: A key of type #gnutls_pubkey_t
 * @url: A PKCS 11 url
 *
 * This function will import a PKCS 11 private key to a #gnutls_private_key_t
 * type.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.1.0
 **/

int gnutls_privkey_import_pkcs11_url(gnutls_privkey_t key, const char *url)
{
	int x;
}
#endif

static
int _gnutls_privkey_import_pkcs11_url(gnutls_privkey_t key, const char *url, unsigned flags)
{
	gnutls_pkcs11_privkey_t pkey;
	int ret;

	ret = gnutls_pkcs11_privkey_init(&pkey);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	if (key->pin.cb)
		gnutls_pkcs11_privkey_set_pin_function(pkey, key->pin.cb,
						       key->pin.data);

	ret = gnutls_pkcs11_privkey_import_url(pkey, url, flags);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	ret =
	    gnutls_privkey_import_pkcs11(key, pkey,
					 GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	return 0;

 cleanup:
	gnutls_pkcs11_privkey_deinit(pkey);

	return ret;
}

/**
 * gnutls_privkey_export_pkcs11:
 * @pkey: The private key
 * @key: Location for the key to be exported.
 *
 * Converts the given abstract private key to a #gnutls_pkcs11_privkey_t
 * type. The key must be of type %GNUTLS_PRIVKEY_PKCS11. The key
 * returned in @key must be deinitialized with
 * gnutls_pkcs11_privkey_deinit().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.4.0
 */
int
gnutls_privkey_export_pkcs11(gnutls_privkey_t pkey,
			     gnutls_pkcs11_privkey_t *key)
{
	int ret;

	if (pkey->type != GNUTLS_PRIVKEY_PKCS11) {
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

	ret = gnutls_pkcs11_privkey_init(key);
	if (ret < 0)
		return gnutls_assert_val(ret);

	ret = gnutls_pkcs11_privkey_cpy(*key, pkey->key.pkcs11);
	if (ret < 0) {
		gnutls_pkcs11_privkey_deinit(*key);
		*key = NULL;

		return gnutls_assert_val(ret);
	}

	return 0;
}
#endif				/* ENABLE_PKCS11 */

/**
 * gnutls_privkey_import_ext:
 * @pkey: The private key
 * @pk: The public key algorithm
 * @userdata: private data to be provided to the callbacks
 * @sign_func: callback for signature operations
 * @decrypt_func: callback for decryption operations
 * @flags: Flags for the import
 *
 * This function will associate the given callbacks with the
 * #gnutls_privkey_t type. At least one of the two callbacks
 * must be non-null.
 *
 * Note that the signing function is supposed to "raw" sign data, i.e.,
 * without any hashing or preprocessing. In case of RSA the DigestInfo
 * will be provided, and the signing function is expected to do the PKCS #1
 * 1.5 padding and the exponentiation.
 *
 * See also gnutls_privkey_import_ext3().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.0
 **/
int
gnutls_privkey_import_ext(gnutls_privkey_t pkey,
			  gnutls_pk_algorithm_t pk,
			  void *userdata,
			  gnutls_privkey_sign_func sign_func,
			  gnutls_privkey_decrypt_func decrypt_func,
			  unsigned int flags)
{
	return gnutls_privkey_import_ext2(pkey, pk, userdata, sign_func,
					  decrypt_func, NULL, flags);
}

#define CHECK_EXT_PK(pk) \
	if (pk != GNUTLS_PK_RSA && pk != GNUTLS_PK_ECDSA && pk != GNUTLS_PK_DSA) \
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST)

/**
 * gnutls_privkey_import_ext2:
 * @pkey: The private key
 * @pk: The public key algorithm
 * @userdata: private data to be provided to the callbacks
 * @sign_fn: callback for signature operations
 * @decrypt_fn: callback for decryption operations
 * @deinit_fn: a deinitialization function
 * @flags: Flags for the import
 *
 * This function will associate the given callbacks with the
 * #gnutls_privkey_t type. At least one of the two callbacks
 * must be non-null. If a deinitialization function is provided
 * then flags is assumed to contain %GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE.
 *
 * Note that the signing function is supposed to "raw" sign data, i.e.,
 * without any hashing or preprocessing. In case of RSA the DigestInfo
 * will be provided, and the signing function is expected to do the PKCS #1
 * 1.5 padding and the exponentiation.
 *
 * See also gnutls_privkey_import_ext3().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.1
 **/
int
gnutls_privkey_import_ext2(gnutls_privkey_t pkey,
			   gnutls_pk_algorithm_t pk,
			   void *userdata,
			   gnutls_privkey_sign_func sign_fn,
			   gnutls_privkey_decrypt_func decrypt_fn,
			   gnutls_privkey_deinit_func deinit_fn,
			   unsigned int flags)
{
	int ret;

	ret = check_if_clean(pkey);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	CHECK_EXT_PK(pk);

	if (sign_fn == NULL && decrypt_fn == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	pkey->key.ext.sign_func = sign_fn;
	pkey->key.ext.decrypt_func = decrypt_fn;
	pkey->key.ext.deinit_func = deinit_fn;
	pkey->key.ext.userdata = userdata;
	pkey->type = GNUTLS_PRIVKEY_EXT;
	pkey->pk_algorithm = pk;
	pkey->flags = flags;

	/* Ensure gnutls_privkey_deinit() calls the deinit_func */
	if (deinit_fn)
		pkey->flags |= GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE;

	return 0;
}

/**
 * gnutls_privkey_import_ext3:
 * @pkey: The private key
 * @userdata: private data to be provided to the callbacks
 * @sign_fn: callback for signature operations
 * @decrypt_fn: callback for decryption operations
 * @deinit_fn: a deinitialization function
 * @info_fn: returns info about the public key algorithm (should not be %NULL)
 * @flags: Flags for the import
 *
 * This function will associate the given callbacks with the
 * #gnutls_privkey_t type. At least one of the two callbacks
 * must be non-null. If a deinitialization function is provided
 * then flags is assumed to contain %GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE.
 *
 * Note that the signing function is supposed to "raw" sign data, i.e.,
 * without any hashing or preprocessing. In case of RSA the DigestInfo
 * will be provided, and the signing function is expected to do the PKCS #1
 * 1.5 padding and the exponentiation.
 *
 * The @info_fn must provide information on the algorithms supported by
 * this private key, and should support the flags %GNUTLS_PRIVKEY_INFO_PK_ALGO and
 * %GNUTLS_PRIVKEY_INFO_SIGN_ALGO. It must return -1 on unknown flags.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.4.0
 **/
int
gnutls_privkey_import_ext3(gnutls_privkey_t pkey,
			   void *userdata,
			   gnutls_privkey_sign_func sign_fn,
			   gnutls_privkey_decrypt_func decrypt_fn,
			   gnutls_privkey_deinit_func deinit_fn,
			   gnutls_privkey_info_func info_fn,
			   unsigned int flags)
{
	int ret;

	ret = check_if_clean(pkey);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	if (sign_fn == NULL && decrypt_fn == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	if (info_fn == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	pkey->key.ext.sign_func = sign_fn;
	pkey->key.ext.decrypt_func = decrypt_fn;
	pkey->key.ext.deinit_func = deinit_fn;
	pkey->key.ext.info_func = info_fn;
	pkey->key.ext.userdata = userdata;
	pkey->type = GNUTLS_PRIVKEY_EXT;
	pkey->flags = flags;

	pkey->pk_algorithm = pkey->key.ext.info_func(pkey, GNUTLS_PRIVKEY_INFO_PK_ALGO, pkey->key.ext.userdata);

	CHECK_EXT_PK(pkey->pk_algorithm);

	/* Ensure gnutls_privkey_deinit() calls the deinit_func */
	if (deinit_fn)
		pkey->flags |= GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE;

	return 0;
}

/**
 * gnutls_privkey_import_x509:
 * @pkey: The private key
 * @key: The private key to be imported
 * @flags: Flags for the import
 *
 * This function will import the given private key to the abstract
 * #gnutls_privkey_t type.
 *
 * The #gnutls_x509_privkey_t object must not be deallocated
 * during the lifetime of this structure.
 *
 * @flags might be zero or one of %GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE
 * and %GNUTLS_PRIVKEY_IMPORT_COPY.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 2.12.0
 **/
int
gnutls_privkey_import_x509(gnutls_privkey_t pkey,
			   gnutls_x509_privkey_t key, unsigned int flags)
{
	int ret;

	ret = check_if_clean(pkey);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	if (flags & GNUTLS_PRIVKEY_IMPORT_COPY) {
		ret = gnutls_x509_privkey_init(&pkey->key.x509);
		if (ret < 0)
			return gnutls_assert_val(ret);

		ret = gnutls_x509_privkey_cpy(pkey->key.x509, key);
		if (ret < 0) {
			gnutls_x509_privkey_deinit(pkey->key.x509);
			return gnutls_assert_val(ret);
		}
	} else
		pkey->key.x509 = key;

	pkey->type = GNUTLS_PRIVKEY_X509;
	pkey->pk_algorithm = gnutls_x509_privkey_get_pk_algorithm(key);
	pkey->flags = flags;

	return 0;
}

/**
 * gnutls_privkey_export_x509:
 * @pkey: The private key
 * @key: Location for the key to be exported.
 *
 * Converts the given abstract private key to a #gnutls_x509_privkey_t
 * type. The abstract key must be of type %GNUTLS_PRIVKEY_X509. The input
 * @key must not be initialized. The key returned in @key should be deinitialized
 * using gnutls_x509_privkey_deinit().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.4.0
 */
int
gnutls_privkey_export_x509(gnutls_privkey_t pkey,
			   gnutls_x509_privkey_t *key)
{
	int ret;

	if (pkey->type != GNUTLS_PRIVKEY_X509) {
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}

	ret = gnutls_x509_privkey_init(key);
	if (ret < 0)
		return gnutls_assert_val(ret);

	ret = gnutls_x509_privkey_cpy(*key, pkey->key.x509);
	if (ret < 0) {
		gnutls_x509_privkey_deinit(*key);
		*key = NULL;

		return gnutls_assert_val(ret);
	}

	return 0;
}

/**
 * gnutls_privkey_generate:
 * @pkey: An initialized private key
 * @algo: is one of the algorithms in #gnutls_pk_algorithm_t.
 * @bits: the size of the parameters to generate
 * @flags: Must be zero or flags from #gnutls_privkey_flags_t.
 *
 * This function will generate a random private key. Note that this
 * function must be called on an empty private key. The flag %GNUTLS_PRIVKEY_FLAG_PROVABLE
 * instructs the key generation process to use algorithms which generate
 * provable parameters out of a seed.
 *
 * Note that when generating an elliptic curve key, the curve
 * can be substituted in the place of the bits parameter using the
 * GNUTLS_CURVE_TO_BITS() macro. The input to the macro is any curve from
 * %gnutls_ecc_curve_t.
 *
 * For DSA keys, if the subgroup size needs to be specified check
 * the GNUTLS_SUBGROUP_TO_BITS() macro.
 *
 * It is recommended to do not set the number of @bits directly, use gnutls_sec_param_to_pk_bits() instead .
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.3.0
 **/
int
gnutls_privkey_generate(gnutls_privkey_t pkey,
			gnutls_pk_algorithm_t algo, unsigned int bits,
			unsigned int flags)
{
	return gnutls_privkey_generate2(pkey, algo, bits, flags, NULL, 0);
}

/**
 * gnutls_privkey_generate2:
 * @pkey: The private key
 * @algo: is one of the algorithms in #gnutls_pk_algorithm_t.
 * @bits: the size of the modulus
 * @flags: Must be zero or flags from #gnutls_privkey_flags_t.
 * @data: Allow specifying %gnutls_keygen_data_st types such as the seed to be used.
 * @data_size: The number of @data available.
 *
 * This function will generate a random private key. Note that this
 * function must be called on an empty private key. The flag %GNUTLS_PRIVKEY_FLAG_PROVABLE
 * instructs the key generation process to use algorithms like Shawe-Taylor
 * which generate provable parameters out of a seed.
 *
 * Note that when generating an elliptic curve key, the curve
 * can be substituted in the place of the bits parameter using the
 * GNUTLS_CURVE_TO_BITS() macro.
 *
 * Do not set the number of bits directly, use gnutls_sec_param_to_pk_bits().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.5.0
 **/
int
gnutls_privkey_generate2(gnutls_privkey_t pkey,
			 gnutls_pk_algorithm_t algo, unsigned int bits,
			 unsigned int flags, const gnutls_keygen_data_st *data, unsigned data_size)
{
	int ret;

	ret = gnutls_x509_privkey_init(&pkey->key.x509);
	if (ret < 0)
		return gnutls_assert_val(ret);

	ret = gnutls_x509_privkey_generate2(pkey->key.x509, algo, bits, flags, data, data_size);
	if (ret < 0) {
		gnutls_x509_privkey_deinit(pkey->key.x509);
		pkey->key.x509 = NULL;
		return gnutls_assert_val(ret);
	}

	pkey->type = GNUTLS_PRIVKEY_X509;
	pkey->pk_algorithm = algo;
	pkey->flags = flags | GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE;

	return 0;
}

/**
 * gnutls_privkey_sign_data:
 * @signer: Holds the key
 * @hash: should be a digest algorithm
 * @flags: Zero or one of %gnutls_privkey_flags_t
 * @data: holds the data to be signed
 * @signature: will contain the signature allocated with gnutls_malloc()
 *
 * This function will sign the given data using a signature algorithm
 * supported by the private key. Signature algorithms are always used
 * together with a hash functions.  Different hash functions may be
 * used for the RSA algorithm, but only the SHA family for the DSA keys.
 *
 * You may use gnutls_pubkey_get_preferred_hash_algorithm() to determine
 * the hash algorithm.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 * negative error value.
 *
 * Since: 2.12.0
 **/
int
gnutls_privkey_sign_data(gnutls_privkey_t signer,
			 gnutls_digest_algorithm_t hash,
			 unsigned int flags,
			 const gnutls_datum_t * data,
			 gnutls_datum_t * signature)
{
	int ret;
	gnutls_x509_spki_st params;

	if (flags & GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	ret = _gnutls_privkey_get_spki_params(signer, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	ret = _gnutls_privkey_update_spki_params(signer, signer->pk_algorithm,
					         hash, flags, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return privkey_sign_and_hash_data(signer, _gnutls_pk_to_sign_entry(params.pk, hash), data, signature, &params);
}

/**
 * gnutls_privkey_sign_data2:
 * @signer: Holds the key
 * @algo: The signature algorithm used
 * @flags: Zero or one of %gnutls_privkey_flags_t
 * @data: holds the data to be signed
 * @signature: will contain the signature allocated with gnutls_malloc()
 *
 * This function will sign the given data using the specified signature
 * algorithm. This function is an enhancement of gnutls_privkey_sign_data(),
 * as it allows utilizing a alternative signature algorithm where possible
 * (e.g, use an RSA key with RSA-PSS).
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 * negative error value.
 *
 * Since: 3.6.0
 **/
int
gnutls_privkey_sign_data2(gnutls_privkey_t signer,
			  gnutls_sign_algorithm_t algo,
			  unsigned int flags,
			  const gnutls_datum_t * data,
			  gnutls_datum_t * signature)
{
	int ret;
	gnutls_x509_spki_st params;
	const gnutls_sign_entry_st *e;

	if (flags & GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	e = _gnutls_sign_to_entry(algo);
	if (e == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	ret = _gnutls_privkey_get_spki_params(signer, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	ret = _gnutls_privkey_update_spki_params(signer, e->pk, e->hash,
					         flags, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return privkey_sign_and_hash_data(signer, _gnutls_sign_to_entry(algo), data, signature, &params);
}

/**
 * gnutls_privkey_sign_hash2:
 * @signer: Holds the signer's key
 * @algo: The signature algorithm used
 * @flags: Zero or one of %gnutls_privkey_flags_t
 * @hash_data: holds the data to be signed
 * @signature: will contain newly allocated signature
 *
 * This function will sign the given hashed data using a signature algorithm
 * supported by the private key. Signature algorithms are always used
 * together with a hash functions.  Different hash functions may be
 * used for the RSA algorithm, but only SHA-XXX for the DSA keys.
 *
 * You may use gnutls_pubkey_get_preferred_hash_algorithm() to determine
 * the hash algorithm.
 *
 * The flags may be %GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA or %GNUTLS_PRIVKEY_SIGN_FLAG_RSA_PSS.
 * In the former case this function will ignore @hash_algo and perform a raw PKCS1 signature,
 * and in the latter an RSA-PSS signature will be generated.
 *
 * Note that, not all algorithm support signing already hashed data. When
 * signing with Ed25519, gnutls_privkey_sign_data() should be used.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.6.0
 **/
int
gnutls_privkey_sign_hash2(gnutls_privkey_t signer,
			  gnutls_sign_algorithm_t algo,
			  unsigned int flags,
			  const gnutls_datum_t * hash_data,
			  gnutls_datum_t * signature)
{
	int ret;
	gnutls_x509_spki_st params;
	const gnutls_sign_entry_st *se;

	se = _gnutls_sign_to_entry(algo);
	if (se == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	ret = _gnutls_privkey_get_spki_params(signer, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	ret = _gnutls_privkey_update_spki_params(signer, se->pk, se->hash,
					         flags, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return privkey_sign_prehashed(signer, se, hash_data, signature, &params, flags);
}

int
privkey_sign_and_hash_data(gnutls_privkey_t signer,
			   const gnutls_sign_entry_st *se,
			   const gnutls_datum_t * data,
			   gnutls_datum_t * signature,
			   gnutls_x509_spki_st * params)
{
	int ret;
	gnutls_datum_t digest;
	const mac_entry_st *me;

	if (se == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	if (_gnutls_pk_is_not_prehashed(se->pk)) {
		return privkey_sign_raw_data(signer, se, data, signature, params);
	}

	me = hash_to_entry(se->hash);
	if (me == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	ret = pk_hash_data(se->pk, me, NULL, data, &digest);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	ret = pk_prepare_hash(se->pk, me, &digest);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	ret = privkey_sign_raw_data(signer, se, &digest, signature, params);
	_gnutls_free_datum(&digest);

	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return 0;

 cleanup:
	_gnutls_free_datum(&digest);
	return ret;
}


/**
 * gnutls_privkey_sign_hash:
 * @signer: Holds the signer's key
 * @hash_algo: The hash algorithm used
 * @flags: Zero or one of %gnutls_privkey_flags_t
 * @hash_data: holds the data to be signed
 * @signature: will contain newly allocated signature
 *
 * This function will sign the given hashed data using a signature algorithm
 * supported by the private key. Signature algorithms are always used
 * together with a hash functions.  Different hash functions may be
 * used for the RSA algorithm, but only SHA-XXX for the DSA keys.
 *
 * You may use gnutls_pubkey_get_preferred_hash_algorithm() to determine
 * the hash algorithm.
 *
 * The flags may be %GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA or %GNUTLS_PRIVKEY_SIGN_FLAG_RSA_PSS.
 * In the former case this function will ignore @hash_algo and perform a raw PKCS1 signature,
 * and in the latter an RSA-PSS signature will be generated.
 *
 * Note that, not all algorithm support signing already hashed data. When
 * signing with Ed25519, gnutls_privkey_sign_data() should be used.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 2.12.0
 **/
int
gnutls_privkey_sign_hash(gnutls_privkey_t signer,
			 gnutls_digest_algorithm_t hash_algo,
			 unsigned int flags,
			 const gnutls_datum_t * hash_data,
			 gnutls_datum_t * signature)
{
	int ret;
	gnutls_x509_spki_st params;

	ret = _gnutls_privkey_get_spki_params(signer, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	ret = _gnutls_privkey_update_spki_params(signer, signer->pk_algorithm,
					       hash_algo, flags, &params);
	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return privkey_sign_prehashed(signer, _gnutls_pk_to_sign_entry(params.pk, hash_algo),
				      hash_data, signature, &params, flags);
}

static int
privkey_sign_prehashed(gnutls_privkey_t signer,
		       const gnutls_sign_entry_st *se,
		       const gnutls_datum_t * hash_data,
		       gnutls_datum_t * signature,
		       gnutls_x509_spki_st * params,
		       unsigned flags)
{
	int ret;
	gnutls_datum_t digest;

	if (flags & GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA)
		return privkey_sign_raw_data(signer,
					     se,
					     hash_data, signature,
					     params);

	if (_gnutls_pk_is_not_prehashed(signer->pk_algorithm)) {
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
	}

	if (se == NULL)
		return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

	digest.data = gnutls_malloc(hash_data->size);
	if (digest.data == NULL) {
		gnutls_assert();
		return GNUTLS_E_MEMORY_ERROR;
	}
	digest.size = hash_data->size;
	memcpy(digest.data, hash_data->data, digest.size);

	ret = pk_prepare_hash(se->pk, hash_to_entry(se->hash), &digest);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	ret = privkey_sign_raw_data(signer,
				    se,
				    &digest, signature,
				    params);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	ret = 0;

 cleanup:
	_gnutls_free_datum(&digest);
	return ret;
}

/*-
 * privkey_sign_raw_data:
 * @key: Holds the key
 * @data: holds the data to be signed
 * @signature: will contain the signature allocated with gnutls_malloc()
 * @params: holds the signing parameters
 *
 * This function will sign the given data using a signature algorithm
 * supported by the private key. Note that this is a low-level function
 * and does not apply any preprocessing or hash on the signed data. 
 * For example on an RSA key the input @data should be of the DigestInfo
 * PKCS #1 1.5 format. Use it only if you know what are you doing.
 *
 * Note this function is equivalent to using the %GNUTLS_PRIVKEY_SIGN_FLAG_TLS1_RSA
 * flag with gnutls_privkey_sign_hash().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 * negative error value.
 *
 * Since: 3.1.10
 -*/
int
privkey_sign_raw_data(gnutls_privkey_t key,
		      const gnutls_sign_entry_st *se,
		      const gnutls_datum_t * data,
		      gnutls_datum_t * signature,
		      gnutls_x509_spki_st * params)
{
	gnutls_pk_algorithm_t pk;

	if (se == NULL) /* it can be null when signing raw-rsa */
		pk = params->pk;
	else
		pk = se->pk;

	switch (key->type) {
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11:
		return _gnutls_pkcs11_privkey_sign(key->key.pkcs11, se,
						   data, signature,
						   params);
#endif
	case GNUTLS_PRIVKEY_X509:
		return _gnutls_pk_sign(pk, signature, data,
				       &key->key.x509->params, params);
	case GNUTLS_PRIVKEY_EXT:
		if (pk == GNUTLS_PK_RSA_PSS || pk == GNUTLS_PK_EDDSA_ED25519)
			return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

		if (key->key.ext.sign_func == NULL)
			return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
		return key->key.ext.sign_func(key, key->key.ext.userdata,
					      data, signature);
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}
}

/**
 * gnutls_privkey_decrypt_data:
 * @key: Holds the key
 * @flags: zero for now
 * @ciphertext: holds the data to be decrypted
 * @plaintext: will contain the decrypted data, allocated with gnutls_malloc()
 *
 * This function will decrypt the given data using the algorithm
 * supported by the private key.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 * negative error value.
 *
 * Since: 2.12.0
 **/
int
gnutls_privkey_decrypt_data(gnutls_privkey_t key,
			    unsigned int flags,
			    const gnutls_datum_t * ciphertext,
			    gnutls_datum_t * plaintext)
{
	switch (key->type) {
	case GNUTLS_PRIVKEY_X509:
		return _gnutls_pk_decrypt(key->pk_algorithm, plaintext,
					  ciphertext, &key->key.x509->params);
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11:
		return _gnutls_pkcs11_privkey_decrypt_data(key->key.pkcs11,
							   flags,
							   ciphertext,
							   plaintext);
#endif
	case GNUTLS_PRIVKEY_EXT:
		if (key->key.ext.decrypt_func == NULL)
			return gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);

		return key->key.ext.decrypt_func(key,
						 key->key.ext.userdata,
						 ciphertext, plaintext);
	default:
		gnutls_assert();
		return GNUTLS_E_INVALID_REQUEST;
	}
}

/**
 * gnutls_privkey_import_x509_raw:
 * @pkey: The private key
 * @data: The private key data to be imported
 * @format: The format of the private key
 * @password: A password (optional)
 * @flags: an ORed sequence of gnutls_pkcs_encrypt_flags_t
 *
 * This function will import the given private key to the abstract
 * #gnutls_privkey_t type. 
 *
 * The supported formats are basic unencrypted key, PKCS8, PKCS12, 
 * and the openssl format.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.1.0
 **/
int gnutls_privkey_import_x509_raw(gnutls_privkey_t pkey,
				   const gnutls_datum_t * data,
				   gnutls_x509_crt_fmt_t format,
				   const char *password, unsigned int flags)
{
	gnutls_x509_privkey_t xpriv;
	int ret;

	ret = gnutls_x509_privkey_init(&xpriv);
	if (ret < 0)
		return gnutls_assert_val(ret);

	if (pkey->pin.cb) {
		gnutls_x509_privkey_set_pin_function(xpriv, pkey->pin.cb,
						     pkey->pin.data);
	}

	ret = gnutls_x509_privkey_import2(xpriv, data, format, password, flags);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	ret =
	    gnutls_privkey_import_x509(pkey, xpriv,
				       GNUTLS_PRIVKEY_IMPORT_AUTO_RELEASE);
	if (ret < 0) {
		gnutls_assert();
		goto cleanup;
	}

	return 0;

 cleanup:
	gnutls_x509_privkey_deinit(xpriv);

	return ret;
}

/**
 * gnutls_privkey_import_url:
 * @key: A key of type #gnutls_privkey_t
 * @url: A PKCS 11 url
 * @flags: should be zero
 *
 * This function will import a PKCS11 or TPM URL as a
 * private key. The supported URL types can be checked
 * using gnutls_url_is_supported().
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.1.0
 **/
int
gnutls_privkey_import_url(gnutls_privkey_t key, const char *url,
			  unsigned int flags)
{
	unsigned i;
	int ret;

	for (i=0;i<_gnutls_custom_urls_size;i++) {
		if (strncmp(url, _gnutls_custom_urls[i].name, _gnutls_custom_urls[i].name_size) == 0) {
			if (_gnutls_custom_urls[i].import_key) {
				ret = _gnutls_custom_urls[i].import_key(key, url, flags);
				goto cleanup;
			}
			break;
		}
	}

	if (strncmp(url, PKCS11_URL, PKCS11_URL_SIZE) == 0) {
#ifdef ENABLE_PKCS11
		ret = _gnutls_privkey_import_pkcs11_url(key, url, flags);
#else
		ret = gnutls_assert_val(GNUTLS_E_UNIMPLEMENTED_FEATURE);
#endif
		goto cleanup;
	}

	if (strncmp(url, TPMKEY_URL, TPMKEY_URL_SIZE) == 0) {
#ifdef HAVE_TROUSERS
		ret = gnutls_privkey_import_tpm_url(key, url, NULL, NULL, 0);
#else
		ret = gnutls_assert_val(GNUTLS_E_UNIMPLEMENTED_FEATURE);
#endif
		goto cleanup;
	}

	if (strncmp(url, SYSTEM_URL, SYSTEM_URL_SIZE) == 0) {
		ret = _gnutls_privkey_import_system_url(key, url);
		goto cleanup;
	}

	ret = gnutls_assert_val(GNUTLS_E_INVALID_REQUEST);
 cleanup:
	return ret;
}

/**
 * gnutls_privkey_set_pin_function:
 * @key: A key of type #gnutls_privkey_t
 * @fn: the callback
 * @userdata: data associated with the callback
 *
 * This function will set a callback function to be used when
 * required to access the object. This function overrides any other
 * global PIN functions.
 *
 * Note that this function must be called right after initialization
 * to have effect.
 *
 * Since: 3.1.0
 *
 **/
void gnutls_privkey_set_pin_function(gnutls_privkey_t key,
				     gnutls_pin_callback_t fn, void *userdata)
{
	key->pin.cb = fn;
	key->pin.data = userdata;
}

/**
 * gnutls_privkey_set_flags:
 * @key: A key of type #gnutls_privkey_t
 * @flags: flags from the %gnutls_privkey_flags
 *
 * This function will set flags for the specified private key, after
 * it is generated. Currently this is useful for the %GNUTLS_PRIVKEY_FLAG_EXPORT_COMPAT
 * to allow exporting a "provable" private key in backwards compatible way.
 *
 * Since: 3.5.0
 *
 **/
void gnutls_privkey_set_flags(gnutls_privkey_t key,
			      unsigned int flags)
{
	key->flags |= flags;
	if (key->type == GNUTLS_PRIVKEY_X509)
		gnutls_x509_privkey_set_flags(key->key.x509, flags);
}

/**
 * gnutls_privkey_status:
 * @key: Holds the key
 *
 * Checks the status of the private key token. This function
 * is an actual wrapper over gnutls_pkcs11_privkey_status(), and
 * if the private key is a PKCS #11 token it will check whether
 * it is inserted or not.
 *
 * Returns: this function will return non-zero if the token 
 * holding the private key is still available (inserted), and zero otherwise.
 * 
 * Since: 3.1.10
 *
 **/
int gnutls_privkey_status(gnutls_privkey_t key)
{
	switch (key->type) {
#ifdef ENABLE_PKCS11
	case GNUTLS_PRIVKEY_PKCS11:
		return gnutls_pkcs11_privkey_status(key->key.pkcs11);
#endif
	default:
		return 1;
	}
}

/**
 * gnutls_privkey_verify_params:
 * @key: should contain a #gnutls_privkey_t type
 *
 * This function will verify the private key parameters.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.3.0
 **/
int gnutls_privkey_verify_params(gnutls_privkey_t key)
{
	gnutls_pk_params_st params;
	int ret;

	gnutls_pk_params_init(&params);

	ret = _gnutls_privkey_get_mpis(key, &params);
	if (ret < 0)
		return gnutls_assert_val(ret);

	ret = _gnutls_pk_verify_priv_params(key->pk_algorithm, &params);

	gnutls_pk_params_release(&params);

	if (ret < 0) {
		gnutls_assert();
		return ret;
	}

	return 0;
}

/*-
 * _gnutls_privkey_get_preferred_sign_algo:
 * @key: should contain a #gnutls_privkey_t type
 *
 * This function returns the preferred signature algorithm for this
 * private key.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.4.0
 -*/
gnutls_sign_algorithm_t
_gnutls_privkey_get_preferred_sign_algo(gnutls_privkey_t key)
{
	if (key->type == GNUTLS_PRIVKEY_EXT) {
		if (key->key.ext.info_func)
			return key->key.ext.info_func(key, GNUTLS_PRIVKEY_INFO_SIGN_ALGO, key->key.ext.userdata);
	}
	return GNUTLS_SIGN_UNKNOWN;
}

/**
 * gnutls_privkey_get_spki:
 * @privkey: a public key of type #gnutls_privkey_t
 * @spki: a SubjectPublicKeyInfo structure of type #gnutls_privkey_spki_t
 * @flags: must be zero
 *
 * This function will return the public key information if available.
 * The provided @spki must be initialized.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.6.0
 **/
int
gnutls_privkey_get_spki(gnutls_privkey_t privkey, gnutls_x509_spki_t spki, unsigned int flags)
{
	if (privkey == NULL || privkey->type != GNUTLS_PRIVKEY_X509) {
		gnutls_assert();
		return GNUTLS_E_REQUESTED_DATA_NOT_AVAILABLE;
	}

	if (privkey->key.x509->params.spki.pk == GNUTLS_PK_UNKNOWN)
		return gnutls_assert_val(GNUTLS_E_REQUESTED_DATA_NOT_AVAILABLE);

	memcpy(spki, &privkey->key.x509->params.spki, sizeof(gnutls_x509_spki_st));

	return 0;
}

/**
 * gnutls_privkey_set_spki:
 * @privkey: a public key of type #gnutls_privkey_t
 * @spki: a SubjectPublicKeyInfo structure of type #gnutls_privkey_spki_t
 * @flags: must be zero
 *
 * This function will set the public key information.
 * The provided @spki must be initialized.
 *
 * Returns: On success, %GNUTLS_E_SUCCESS (0) is returned, otherwise a
 *   negative error value.
 *
 * Since: 3.6.0
 **/
int
gnutls_privkey_set_spki(gnutls_privkey_t privkey, const gnutls_x509_spki_t spki, unsigned int flags)
{
	if (privkey == NULL || privkey->type != GNUTLS_PRIVKEY_X509) {
		gnutls_assert();
		return GNUTLS_E_REQUESTED_DATA_NOT_AVAILABLE;
	}

	return gnutls_x509_privkey_set_spki(privkey->key.x509, spki, flags);
}

/* Checks whether the public key given is compatible with the
 * signature algorithm used. The session is only used for audit logging, and
 * it may be null.
 */
unsigned _gnutls_privkey_compatible_with_sig(gnutls_privkey_t privkey,
				        gnutls_sign_algorithm_t sign)
{
	const gnutls_sign_entry_st *se;

	se = _gnutls_sign_to_entry(sign);
	if (unlikely(se == NULL))
		return gnutls_assert_val(0);

	/* Prevent RSA-PSS private keys from negotiating an RSA signature,
	 * and RSA keys which cannot do RSA-PSS (e.g., smart card) from
	 * negotiating RSA-PSS sig.
	 */
	if (privkey->pk_algorithm == GNUTLS_PK_RSA_PSS && se->pk != GNUTLS_PK_RSA_PSS) {
			return 0;
	}

	if (privkey->type == GNUTLS_PRIVKEY_EXT) {
		/* This key type is very limited on what it can handle */
		if (se->pk == GNUTLS_PK_EDDSA_ED25519)
			return 0;

		if (se->pk == GNUTLS_PK_RSA_PSS)
			return 0;
	}
#ifdef ENABLE_PKCS11
	else if (privkey->type == GNUTLS_PRIVKEY_PKCS11) {
		if (privkey->pk_algorithm == GNUTLS_PK_RSA && se->pk == GNUTLS_PK_RSA_PSS) {
			if (!privkey->key.pkcs11->rsa_pss_ok)
				return 0;
		}
	}
#endif

	return 1;
}
