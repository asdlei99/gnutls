/* t-openpgp.c -- OpenPGP regression test */
  
#include "gnutls_int.h"
#include "gnutls_errors.h"
#include "gnutls_mpi.h"
#include "gnutls_cert.h"
#include "gnutls_datum.h"
#include "gnutls_global.h"
#include "auth_cert.h"
#include "gnutls_openpgp.h"

#include <gnutls_str.h>
#include <stdio.h>
#include <gcrypt.h>
#include <time.h>
#include <assert.h>

static const char *
get_pkalgo( int algo )
{
    switch( algo ) {
    case GNUTLS_PK_DSA: return "DSA";
    case GNUTLS_PK_RSA: return "RSA";
    }
    return NULL;
}

int
get_pubkey( gnutls_datum *pk, const gnutls_datum *kr, unsigned long kid )
{
    unsigned char buf[4];

    buf[0] = kid >> 24;
    buf[1] = kid >> 16;
    buf[2] = kid >>  8;
    buf[3] = kid;
    return gnutls_openpgp_get_key( pk, kr, KEY_ATTR_SHORT_KEYID, buf );
}
    

int
main( int argc, char ** argv )
{
    gnutls_certificate_credentials ctx;
    gnutls_datum dat, xml, pk;
    gnutls_openpgp_name uid;
    gnutls_private_key * pkey;
    unsigned char fpr[20], keyid[8];
    char *s, *t;
    size_t fprlen = 0;
    int rc, nbits = 0, i;

    rc = gnutls_certificate_allocate_cred( &ctx );
    assert( rc == 0 );

    s = "../src/openpgp/cli_ring.gpg";
    rc = gnutls_certificate_set_openpgp_keyring_file( ctx, s );
    assert( rc == 0 );

    s = "../src/openpgp/pub.asc";
    t = "../src/openpgp/sec.asc";
    rc = gnutls_certificate_set_openpgp_key_file( ctx, s, t);
    assert( rc == 0 );
    
    dat = ctx->cert_list[0]->raw;
    assert( ctx->cert_list[0] );
    printf( "Key v%d\n", gnutls_openpgp_extract_key_version( &dat ) );
    rc = gnutls_openpgp_extract_key_name( &dat, 1, &uid );
    assert( rc == 0 );
    printf( "userID    %s\n", uid.name );

    rc = gnutls_openpgp_extract_key_pk_algorithm( &dat, &nbits );
    printf( "pk-algorithm %s %d bits\n", get_pkalgo( rc ), nbits );

    rc = gnutls_openpgp_extract_key_creation_time( &dat );
    printf( "creation time %lu\n", rc );

    rc = gnutls_openpgp_extract_key_expiration_time( &dat );
    printf( "expiration time %lu\n", rc );

    printf( "key fingerprint: " );
    rc = gnutls_openpgp_fingerprint( &dat, fpr, &fprlen );
    assert( rc == 0 );
    for( i = 0; i < fprlen; i++ )
        printf( "%02X ", fpr[i] );
    printf( "\n" );

    printf( "key id: " );
    rc = gnutls_openpgp_extract_key_id( &dat, keyid );
    assert( rc == 0 );
    for( i = 0; i < 8; i++ )
        printf( "%02X", keyid[i] );
    printf( "\n" );

    printf( "\nCheck key\n" );
    rc = gnutls_openpgp_verify_key( NULL, &ctx->keyring, &dat, 1 );
    printf( "certifiacte status...%d\n", rc );

    printf( "\nSeckey\n" );
    pkey = ctx->pkey;
    assert( pkey );
    assert( pkey->params_size );
    nbits = gcry_mpi_get_nbits( pkey->params[0] );
    rc = pkey->pk_algorithm;
    printf ("pk-algorithm %s %d bits\n", get_pkalgo( rc ), nbits );
    for( i = 1; i < pkey->params_size; i++ ) {
        nbits = gcry_mpi_get_nbits( pkey->params[i] );
        printf( "mpi %d %d bits\n",  i, nbits );
    }

    printf( "\nGet public key\n" );
    rc = get_pubkey( &pk, &ctx->keyring, 0xA7D93C3F );
    assert( rc == 0 );

    printf( "key fingerprint: " );
    gnutls_openpgp_fingerprint( &pk, fpr, &fprlen );
    for( i = 0; i < fprlen; i++ )
        printf( "%02X ", fpr[i] );
    printf( "\n" );
    gnutls_free_datum( &pk );
    
    #if 0
    rc = gnutls_openpgp_key_to_xml( &dat, &xml, 1 );
    printf( "rc=%d\n", rc );
    assert( rc == 0 );
    xml.data[xml.size] = '\0';
    printf( "%s\n", xml.data );
    gnutls_free_datum( &xml );
    #endif

    gnutls_free_datum( &dat );
    gnutls_certificate_free_cred( ctx );

    return 0;
}


