# Copyright (c) 2011-2013, Andy Polyakov <appro@openssl.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 
#     * Redistributions of source code must retain copyright notices,
#      this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials
#      provided with the distribution.
#
#     * Neither the name of the Andy Polyakov nor the names of its
#      copyright holder and contributors may be used to endorse or
#      promote products derived from this software without specific
#      prior written permission.
#
# ALTERNATIVELY, provided that this notice is retained in full, this
# product may be distributed under the terms of the GNU General Public
# License (GPL), in which case the provisions of the GPL apply INSTEAD OF
# those given above.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# *** This file is auto-generated ***
#
.file	"devel/perlasm/aesni-x86.s"
.text
.globl	_aesni_encrypt
.def	_aesni_encrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_encrypt:
.L_aesni_encrypt_begin:
	movl	4(%esp),%eax
	movl	12(%esp),%edx
	movups	(%eax),%xmm2
	movl	240(%edx),%ecx
	movl	8(%esp),%eax
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L000enc1_loop_1:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L000enc1_loop_1
.byte	102,15,56,221,209
	movups	%xmm2,(%eax)
	ret
.globl	_aesni_decrypt
.def	_aesni_decrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_decrypt:
.L_aesni_decrypt_begin:
	movl	4(%esp),%eax
	movl	12(%esp),%edx
	movups	(%eax),%xmm2
	movl	240(%edx),%ecx
	movl	8(%esp),%eax
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L001dec1_loop_2:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L001dec1_loop_2
.byte	102,15,56,223,209
	movups	%xmm2,(%eax)
	ret
.def	__aesni_encrypt2;	.scl	3;	.type	32;	.endef
.align	16
__aesni_encrypt2:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
	addl	$16,%ecx
.L002enc2_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L002enc2_loop
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,221,208
.byte	102,15,56,221,216
	ret
.def	__aesni_decrypt2;	.scl	3;	.type	32;	.endef
.align	16
__aesni_decrypt2:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
	addl	$16,%ecx
.L003dec2_loop:
.byte	102,15,56,222,209
.byte	102,15,56,222,217
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L003dec2_loop
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,223,208
.byte	102,15,56,223,216
	ret
.def	__aesni_encrypt3;	.scl	3;	.type	32;	.endef
.align	16
__aesni_encrypt3:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
	addl	$16,%ecx
.L004enc3_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L004enc3_loop
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,221,208
.byte	102,15,56,221,216
.byte	102,15,56,221,224
	ret
.def	__aesni_decrypt3;	.scl	3;	.type	32;	.endef
.align	16
__aesni_decrypt3:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
	addl	$16,%ecx
.L005dec3_loop:
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L005dec3_loop
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,223,208
.byte	102,15,56,223,216
.byte	102,15,56,223,224
	ret
.def	__aesni_encrypt4;	.scl	3;	.type	32;	.endef
.align	16
__aesni_encrypt4:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	shll	$4,%ecx
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
	pxor	%xmm0,%xmm5
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
.byte	15,31,64,0
	addl	$16,%ecx
.L006enc4_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
.byte	102,15,56,220,232
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L006enc4_loop
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
.byte	102,15,56,221,208
.byte	102,15,56,221,216
.byte	102,15,56,221,224
.byte	102,15,56,221,232
	ret
.def	__aesni_decrypt4;	.scl	3;	.type	32;	.endef
.align	16
__aesni_decrypt4:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	shll	$4,%ecx
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
	pxor	%xmm0,%xmm5
	movups	32(%edx),%xmm0
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
.byte	15,31,64,0
	addl	$16,%ecx
.L007dec4_loop:
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
.byte	102,15,56,222,232
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L007dec4_loop
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
.byte	102,15,56,223,208
.byte	102,15,56,223,216
.byte	102,15,56,223,224
.byte	102,15,56,223,232
	ret
.def	__aesni_encrypt6;	.scl	3;	.type	32;	.endef
.align	16
__aesni_encrypt6:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
.byte	102,15,56,220,209
	pxor	%xmm0,%xmm5
	pxor	%xmm0,%xmm6
.byte	102,15,56,220,217
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
.byte	102,15,56,220,225
	pxor	%xmm0,%xmm7
	addl	$16,%ecx
.byte	102,15,56,220,233
.byte	102,15,56,220,241
.byte	102,15,56,220,249
	movups	-16(%edx,%ecx,1),%xmm0
	jmp	.L_aesni_encrypt6_enter
.align	16
.L008enc6_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
.byte	102,15,56,220,241
.byte	102,15,56,220,249
.L_aesni_encrypt6_enter:
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
.byte	102,15,56,220,224
.byte	102,15,56,220,232
.byte	102,15,56,220,240
.byte	102,15,56,220,248
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L008enc6_loop
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,220,225
.byte	102,15,56,220,233
.byte	102,15,56,220,241
.byte	102,15,56,220,249
.byte	102,15,56,221,208
.byte	102,15,56,221,216
.byte	102,15,56,221,224
.byte	102,15,56,221,232
.byte	102,15,56,221,240
.byte	102,15,56,221,248
	ret
.def	__aesni_decrypt6;	.scl	3;	.type	32;	.endef
.align	16
__aesni_decrypt6:
	movups	(%edx),%xmm0
	shll	$4,%ecx
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm2
	pxor	%xmm0,%xmm3
	pxor	%xmm0,%xmm4
.byte	102,15,56,222,209
	pxor	%xmm0,%xmm5
	pxor	%xmm0,%xmm6
.byte	102,15,56,222,217
	leal	32(%edx,%ecx,1),%edx
	negl	%ecx
.byte	102,15,56,222,225
	pxor	%xmm0,%xmm7
	addl	$16,%ecx
.byte	102,15,56,222,233
.byte	102,15,56,222,241
.byte	102,15,56,222,249
	movups	-16(%edx,%ecx,1),%xmm0
	jmp	.L_aesni_decrypt6_enter
.align	16
.L009dec6_loop:
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
.byte	102,15,56,222,241
.byte	102,15,56,222,249
.L_aesni_decrypt6_enter:
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,222,208
.byte	102,15,56,222,216
.byte	102,15,56,222,224
.byte	102,15,56,222,232
.byte	102,15,56,222,240
.byte	102,15,56,222,248
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L009dec6_loop
.byte	102,15,56,222,209
.byte	102,15,56,222,217
.byte	102,15,56,222,225
.byte	102,15,56,222,233
.byte	102,15,56,222,241
.byte	102,15,56,222,249
.byte	102,15,56,223,208
.byte	102,15,56,223,216
.byte	102,15,56,223,224
.byte	102,15,56,223,232
.byte	102,15,56,223,240
.byte	102,15,56,223,248
	ret
.globl	_aesni_ecb_encrypt
.def	_aesni_ecb_encrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_ecb_encrypt:
.L_aesni_ecb_encrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	36(%esp),%ebx
	andl	$-16,%eax
	jz	.L010ecb_ret
	movl	240(%edx),%ecx
	testl	%ebx,%ebx
	jz	.L011ecb_decrypt
	movl	%edx,%ebp
	movl	%ecx,%ebx
	cmpl	$96,%eax
	jb	.L012ecb_enc_tail
	movdqu	(%esi),%xmm2
	movdqu	16(%esi),%xmm3
	movdqu	32(%esi),%xmm4
	movdqu	48(%esi),%xmm5
	movdqu	64(%esi),%xmm6
	movdqu	80(%esi),%xmm7
	leal	96(%esi),%esi
	subl	$96,%eax
	jmp	.L013ecb_enc_loop6_enter
.align	16
.L014ecb_enc_loop6:
	movups	%xmm2,(%edi)
	movdqu	(%esi),%xmm2
	movups	%xmm3,16(%edi)
	movdqu	16(%esi),%xmm3
	movups	%xmm4,32(%edi)
	movdqu	32(%esi),%xmm4
	movups	%xmm5,48(%edi)
	movdqu	48(%esi),%xmm5
	movups	%xmm6,64(%edi)
	movdqu	64(%esi),%xmm6
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	movdqu	80(%esi),%xmm7
	leal	96(%esi),%esi
.L013ecb_enc_loop6_enter:
	call	__aesni_encrypt6
	movl	%ebp,%edx
	movl	%ebx,%ecx
	subl	$96,%eax
	jnc	.L014ecb_enc_loop6
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	addl	$96,%eax
	jz	.L010ecb_ret
.L012ecb_enc_tail:
	movups	(%esi),%xmm2
	cmpl	$32,%eax
	jb	.L015ecb_enc_one
	movups	16(%esi),%xmm3
	je	.L016ecb_enc_two
	movups	32(%esi),%xmm4
	cmpl	$64,%eax
	jb	.L017ecb_enc_three
	movups	48(%esi),%xmm5
	je	.L018ecb_enc_four
	movups	64(%esi),%xmm6
	xorps	%xmm7,%xmm7
	call	__aesni_encrypt6
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	jmp	.L010ecb_ret
.align	16
.L015ecb_enc_one:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L019enc1_loop_3:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L019enc1_loop_3
.byte	102,15,56,221,209
	movups	%xmm2,(%edi)
	jmp	.L010ecb_ret
.align	16
.L016ecb_enc_two:
	call	__aesni_encrypt2
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	jmp	.L010ecb_ret
.align	16
.L017ecb_enc_three:
	call	__aesni_encrypt3
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	jmp	.L010ecb_ret
.align	16
.L018ecb_enc_four:
	call	__aesni_encrypt4
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	jmp	.L010ecb_ret
.align	16
.L011ecb_decrypt:
	movl	%edx,%ebp
	movl	%ecx,%ebx
	cmpl	$96,%eax
	jb	.L020ecb_dec_tail
	movdqu	(%esi),%xmm2
	movdqu	16(%esi),%xmm3
	movdqu	32(%esi),%xmm4
	movdqu	48(%esi),%xmm5
	movdqu	64(%esi),%xmm6
	movdqu	80(%esi),%xmm7
	leal	96(%esi),%esi
	subl	$96,%eax
	jmp	.L021ecb_dec_loop6_enter
.align	16
.L022ecb_dec_loop6:
	movups	%xmm2,(%edi)
	movdqu	(%esi),%xmm2
	movups	%xmm3,16(%edi)
	movdqu	16(%esi),%xmm3
	movups	%xmm4,32(%edi)
	movdqu	32(%esi),%xmm4
	movups	%xmm5,48(%edi)
	movdqu	48(%esi),%xmm5
	movups	%xmm6,64(%edi)
	movdqu	64(%esi),%xmm6
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	movdqu	80(%esi),%xmm7
	leal	96(%esi),%esi
.L021ecb_dec_loop6_enter:
	call	__aesni_decrypt6
	movl	%ebp,%edx
	movl	%ebx,%ecx
	subl	$96,%eax
	jnc	.L022ecb_dec_loop6
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	addl	$96,%eax
	jz	.L010ecb_ret
.L020ecb_dec_tail:
	movups	(%esi),%xmm2
	cmpl	$32,%eax
	jb	.L023ecb_dec_one
	movups	16(%esi),%xmm3
	je	.L024ecb_dec_two
	movups	32(%esi),%xmm4
	cmpl	$64,%eax
	jb	.L025ecb_dec_three
	movups	48(%esi),%xmm5
	je	.L026ecb_dec_four
	movups	64(%esi),%xmm6
	xorps	%xmm7,%xmm7
	call	__aesni_decrypt6
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	jmp	.L010ecb_ret
.align	16
.L023ecb_dec_one:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L027dec1_loop_4:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L027dec1_loop_4
.byte	102,15,56,223,209
	movups	%xmm2,(%edi)
	jmp	.L010ecb_ret
.align	16
.L024ecb_dec_two:
	call	__aesni_decrypt2
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	jmp	.L010ecb_ret
.align	16
.L025ecb_dec_three:
	call	__aesni_decrypt3
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	jmp	.L010ecb_ret
.align	16
.L026ecb_dec_four:
	call	__aesni_decrypt4
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
.L010ecb_ret:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_ccm64_encrypt_blocks
.def	_aesni_ccm64_encrypt_blocks;	.scl	2;	.type	32;	.endef
.align	16
_aesni_ccm64_encrypt_blocks:
.L_aesni_ccm64_encrypt_blocks_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	36(%esp),%ebx
	movl	40(%esp),%ecx
	movl	%esp,%ebp
	subl	$60,%esp
	andl	$-16,%esp
	movl	%ebp,48(%esp)
	movdqu	(%ebx),%xmm7
	movdqu	(%ecx),%xmm3
	movl	240(%edx),%ecx
	movl	$202182159,(%esp)
	movl	$134810123,4(%esp)
	movl	$67438087,8(%esp)
	movl	$66051,12(%esp)
	movl	$1,%ebx
	xorl	%ebp,%ebp
	movl	%ebx,16(%esp)
	movl	%ebp,20(%esp)
	movl	%ebp,24(%esp)
	movl	%ebp,28(%esp)
	shll	$4,%ecx
	movl	$16,%ebx
	leal	(%edx),%ebp
	movdqa	(%esp),%xmm5
	movdqa	%xmm7,%xmm2
	leal	32(%edx,%ecx,1),%edx
	subl	%ecx,%ebx
.byte	102,15,56,0,253
.L028ccm64_enc_outer:
	movups	(%ebp),%xmm0
	movl	%ebx,%ecx
	movups	(%esi),%xmm6
	xorps	%xmm0,%xmm2
	movups	16(%ebp),%xmm1
	xorps	%xmm6,%xmm0
	xorps	%xmm0,%xmm3
	movups	32(%ebp),%xmm0
.L029ccm64_enc2_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L029ccm64_enc2_loop
.byte	102,15,56,220,209
.byte	102,15,56,220,217
	paddq	16(%esp),%xmm7
	decl	%eax
.byte	102,15,56,221,208
.byte	102,15,56,221,216
	leal	16(%esi),%esi
	xorps	%xmm2,%xmm6
	movdqa	%xmm7,%xmm2
	movups	%xmm6,(%edi)
.byte	102,15,56,0,213
	leal	16(%edi),%edi
	jnz	.L028ccm64_enc_outer
	movl	48(%esp),%esp
	movl	40(%esp),%edi
	movups	%xmm3,(%edi)
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_ccm64_decrypt_blocks
.def	_aesni_ccm64_decrypt_blocks;	.scl	2;	.type	32;	.endef
.align	16
_aesni_ccm64_decrypt_blocks:
.L_aesni_ccm64_decrypt_blocks_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	36(%esp),%ebx
	movl	40(%esp),%ecx
	movl	%esp,%ebp
	subl	$60,%esp
	andl	$-16,%esp
	movl	%ebp,48(%esp)
	movdqu	(%ebx),%xmm7
	movdqu	(%ecx),%xmm3
	movl	240(%edx),%ecx
	movl	$202182159,(%esp)
	movl	$134810123,4(%esp)
	movl	$67438087,8(%esp)
	movl	$66051,12(%esp)
	movl	$1,%ebx
	xorl	%ebp,%ebp
	movl	%ebx,16(%esp)
	movl	%ebp,20(%esp)
	movl	%ebp,24(%esp)
	movl	%ebp,28(%esp)
	movdqa	(%esp),%xmm5
	movdqa	%xmm7,%xmm2
	movl	%edx,%ebp
	movl	%ecx,%ebx
.byte	102,15,56,0,253
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L030enc1_loop_5:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L030enc1_loop_5
.byte	102,15,56,221,209
	shll	$4,%ebx
	movl	$16,%ecx
	movups	(%esi),%xmm6
	paddq	16(%esp),%xmm7
	leal	16(%esi),%esi
	subl	%ebx,%ecx
	leal	32(%ebp,%ebx,1),%edx
	movl	%ecx,%ebx
	jmp	.L031ccm64_dec_outer
.align	16
.L031ccm64_dec_outer:
	xorps	%xmm2,%xmm6
	movdqa	%xmm7,%xmm2
	movups	%xmm6,(%edi)
	leal	16(%edi),%edi
.byte	102,15,56,0,213
	subl	$1,%eax
	jz	.L032ccm64_dec_break
	movups	(%ebp),%xmm0
	movl	%ebx,%ecx
	movups	16(%ebp),%xmm1
	xorps	%xmm0,%xmm6
	xorps	%xmm0,%xmm2
	xorps	%xmm6,%xmm3
	movups	32(%ebp),%xmm0
.L033ccm64_dec2_loop:
.byte	102,15,56,220,209
.byte	102,15,56,220,217
	movups	(%edx,%ecx,1),%xmm1
	addl	$32,%ecx
.byte	102,15,56,220,208
.byte	102,15,56,220,216
	movups	-16(%edx,%ecx,1),%xmm0
	jnz	.L033ccm64_dec2_loop
	movups	(%esi),%xmm6
	paddq	16(%esp),%xmm7
.byte	102,15,56,220,209
.byte	102,15,56,220,217
.byte	102,15,56,221,208
.byte	102,15,56,221,216
	leal	16(%esi),%esi
	jmp	.L031ccm64_dec_outer
.align	16
.L032ccm64_dec_break:
	movl	240(%ebp),%ecx
	movl	%ebp,%edx
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm6
	leal	32(%edx),%edx
	xorps	%xmm6,%xmm3
.L034enc1_loop_6:
.byte	102,15,56,220,217
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L034enc1_loop_6
.byte	102,15,56,221,217
	movl	48(%esp),%esp
	movl	40(%esp),%edi
	movups	%xmm3,(%edi)
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_ctr32_encrypt_blocks
.def	_aesni_ctr32_encrypt_blocks;	.scl	2;	.type	32;	.endef
.align	16
_aesni_ctr32_encrypt_blocks:
.L_aesni_ctr32_encrypt_blocks_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	36(%esp),%ebx
	movl	%esp,%ebp
	subl	$88,%esp
	andl	$-16,%esp
	movl	%ebp,80(%esp)
	cmpl	$1,%eax
	je	.L035ctr32_one_shortcut
	movdqu	(%ebx),%xmm7
	movl	$202182159,(%esp)
	movl	$134810123,4(%esp)
	movl	$67438087,8(%esp)
	movl	$66051,12(%esp)
	movl	$6,%ecx
	xorl	%ebp,%ebp
	movl	%ecx,16(%esp)
	movl	%ecx,20(%esp)
	movl	%ecx,24(%esp)
	movl	%ebp,28(%esp)
.byte	102,15,58,22,251,3
.byte	102,15,58,34,253,3
	movl	240(%edx),%ecx
	bswap	%ebx
	pxor	%xmm0,%xmm0
	pxor	%xmm1,%xmm1
	movdqa	(%esp),%xmm2
.byte	102,15,58,34,195,0
	leal	3(%ebx),%ebp
.byte	102,15,58,34,205,0
	incl	%ebx
.byte	102,15,58,34,195,1
	incl	%ebp
.byte	102,15,58,34,205,1
	incl	%ebx
.byte	102,15,58,34,195,2
	incl	%ebp
.byte	102,15,58,34,205,2
	movdqa	%xmm0,48(%esp)
.byte	102,15,56,0,194
	movdqu	(%edx),%xmm6
	movdqa	%xmm1,64(%esp)
.byte	102,15,56,0,202
	pshufd	$192,%xmm0,%xmm2
	pshufd	$128,%xmm0,%xmm3
	cmpl	$6,%eax
	jb	.L036ctr32_tail
	pxor	%xmm6,%xmm7
	shll	$4,%ecx
	movl	$16,%ebx
	movdqa	%xmm7,32(%esp)
	movl	%edx,%ebp
	subl	%ecx,%ebx
	leal	32(%edx,%ecx,1),%edx
	subl	$6,%eax
	jmp	.L037ctr32_loop6
.align	16
.L037ctr32_loop6:
	pshufd	$64,%xmm0,%xmm4
	movdqa	32(%esp),%xmm0
	pshufd	$192,%xmm1,%xmm5
	pxor	%xmm0,%xmm2
	pshufd	$128,%xmm1,%xmm6
	pxor	%xmm0,%xmm3
	pshufd	$64,%xmm1,%xmm7
	movups	16(%ebp),%xmm1
	pxor	%xmm0,%xmm4
	pxor	%xmm0,%xmm5
.byte	102,15,56,220,209
	pxor	%xmm0,%xmm6
	pxor	%xmm0,%xmm7
.byte	102,15,56,220,217
	movups	32(%ebp),%xmm0
	movl	%ebx,%ecx
.byte	102,15,56,220,225
.byte	102,15,56,220,233
.byte	102,15,56,220,241
.byte	102,15,56,220,249
	call	.L_aesni_encrypt6_enter
	movups	(%esi),%xmm1
	movups	16(%esi),%xmm0
	xorps	%xmm1,%xmm2
	movups	32(%esi),%xmm1
	xorps	%xmm0,%xmm3
	movups	%xmm2,(%edi)
	movdqa	16(%esp),%xmm0
	xorps	%xmm1,%xmm4
	movdqa	64(%esp),%xmm1
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	paddd	%xmm0,%xmm1
	paddd	48(%esp),%xmm0
	movdqa	(%esp),%xmm2
	movups	48(%esi),%xmm3
	movups	64(%esi),%xmm4
	xorps	%xmm3,%xmm5
	movups	80(%esi),%xmm3
	leal	96(%esi),%esi
	movdqa	%xmm0,48(%esp)
.byte	102,15,56,0,194
	xorps	%xmm4,%xmm6
	movups	%xmm5,48(%edi)
	xorps	%xmm3,%xmm7
	movdqa	%xmm1,64(%esp)
.byte	102,15,56,0,202
	movups	%xmm6,64(%edi)
	pshufd	$192,%xmm0,%xmm2
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	pshufd	$128,%xmm0,%xmm3
	subl	$6,%eax
	jnc	.L037ctr32_loop6
	addl	$6,%eax
	jz	.L038ctr32_ret
	movdqu	(%ebp),%xmm7
	movl	%ebp,%edx
	pxor	32(%esp),%xmm7
	movl	240(%ebp),%ecx
.L036ctr32_tail:
	por	%xmm7,%xmm2
	cmpl	$2,%eax
	jb	.L039ctr32_one
	pshufd	$64,%xmm0,%xmm4
	por	%xmm7,%xmm3
	je	.L040ctr32_two
	pshufd	$192,%xmm1,%xmm5
	por	%xmm7,%xmm4
	cmpl	$4,%eax
	jb	.L041ctr32_three
	pshufd	$128,%xmm1,%xmm6
	por	%xmm7,%xmm5
	je	.L042ctr32_four
	por	%xmm7,%xmm6
	call	__aesni_encrypt6
	movups	(%esi),%xmm1
	movups	16(%esi),%xmm0
	xorps	%xmm1,%xmm2
	movups	32(%esi),%xmm1
	xorps	%xmm0,%xmm3
	movups	48(%esi),%xmm0
	xorps	%xmm1,%xmm4
	movups	64(%esi),%xmm1
	xorps	%xmm0,%xmm5
	movups	%xmm2,(%edi)
	xorps	%xmm1,%xmm6
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	jmp	.L038ctr32_ret
.align	16
.L035ctr32_one_shortcut:
	movups	(%ebx),%xmm2
	movl	240(%edx),%ecx
.L039ctr32_one:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L043enc1_loop_7:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L043enc1_loop_7
.byte	102,15,56,221,209
	movups	(%esi),%xmm6
	xorps	%xmm2,%xmm6
	movups	%xmm6,(%edi)
	jmp	.L038ctr32_ret
.align	16
.L040ctr32_two:
	call	__aesni_encrypt2
	movups	(%esi),%xmm5
	movups	16(%esi),%xmm6
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	jmp	.L038ctr32_ret
.align	16
.L041ctr32_three:
	call	__aesni_encrypt3
	movups	(%esi),%xmm5
	movups	16(%esi),%xmm6
	xorps	%xmm5,%xmm2
	movups	32(%esi),%xmm7
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	xorps	%xmm7,%xmm4
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	jmp	.L038ctr32_ret
.align	16
.L042ctr32_four:
	call	__aesni_encrypt4
	movups	(%esi),%xmm6
	movups	16(%esi),%xmm7
	movups	32(%esi),%xmm1
	xorps	%xmm6,%xmm2
	movups	48(%esi),%xmm0
	xorps	%xmm7,%xmm3
	movups	%xmm2,(%edi)
	xorps	%xmm1,%xmm4
	movups	%xmm3,16(%edi)
	xorps	%xmm0,%xmm5
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
.L038ctr32_ret:
	movl	80(%esp),%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_xts_encrypt
.def	_aesni_xts_encrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_xts_encrypt:
.L_aesni_xts_encrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	36(%esp),%edx
	movl	40(%esp),%esi
	movl	240(%edx),%ecx
	movups	(%esi),%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L044enc1_loop_8:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L044enc1_loop_8
.byte	102,15,56,221,209
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	%esp,%ebp
	subl	$120,%esp
	movl	240(%edx),%ecx
	andl	$-16,%esp
	movl	$135,96(%esp)
	movl	$0,100(%esp)
	movl	$1,104(%esp)
	movl	$0,108(%esp)
	movl	%eax,112(%esp)
	movl	%ebp,116(%esp)
	movdqa	%xmm2,%xmm1
	pxor	%xmm0,%xmm0
	movdqa	96(%esp),%xmm3
	pcmpgtd	%xmm1,%xmm0
	andl	$-16,%eax
	movl	%edx,%ebp
	movl	%ecx,%ebx
	subl	$96,%eax
	jc	.L045xts_enc_short
	shll	$4,%ecx
	movl	$16,%ebx
	subl	%ecx,%ebx
	leal	32(%edx,%ecx,1),%edx
	jmp	.L046xts_enc_loop6
.align	16
.L046xts_enc_loop6:
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,16(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,32(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,48(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm7
	movdqa	%xmm1,64(%esp)
	paddq	%xmm1,%xmm1
	movups	(%ebp),%xmm0
	pand	%xmm3,%xmm7
	movups	(%esi),%xmm2
	pxor	%xmm1,%xmm7
	movl	%ebx,%ecx
	movdqu	16(%esi),%xmm3
	xorps	%xmm0,%xmm2
	movdqu	32(%esi),%xmm4
	pxor	%xmm0,%xmm3
	movdqu	48(%esi),%xmm5
	pxor	%xmm0,%xmm4
	movdqu	64(%esi),%xmm6
	pxor	%xmm0,%xmm5
	movdqu	80(%esi),%xmm1
	pxor	%xmm0,%xmm6
	leal	96(%esi),%esi
	pxor	(%esp),%xmm2
	movdqa	%xmm7,80(%esp)
	pxor	%xmm1,%xmm7
	movups	16(%ebp),%xmm1
	pxor	16(%esp),%xmm3
	pxor	32(%esp),%xmm4
.byte	102,15,56,220,209
	pxor	48(%esp),%xmm5
	pxor	64(%esp),%xmm6
.byte	102,15,56,220,217
	pxor	%xmm0,%xmm7
	movups	32(%ebp),%xmm0
.byte	102,15,56,220,225
.byte	102,15,56,220,233
.byte	102,15,56,220,241
.byte	102,15,56,220,249
	call	.L_aesni_encrypt6_enter
	movdqa	80(%esp),%xmm1
	pxor	%xmm0,%xmm0
	xorps	(%esp),%xmm2
	pcmpgtd	%xmm1,%xmm0
	xorps	16(%esp),%xmm3
	movups	%xmm2,(%edi)
	xorps	32(%esp),%xmm4
	movups	%xmm3,16(%edi)
	xorps	48(%esp),%xmm5
	movups	%xmm4,32(%edi)
	xorps	64(%esp),%xmm6
	movups	%xmm5,48(%edi)
	xorps	%xmm1,%xmm7
	movups	%xmm6,64(%edi)
	pshufd	$19,%xmm0,%xmm2
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	movdqa	96(%esp),%xmm3
	pxor	%xmm0,%xmm0
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	subl	$96,%eax
	jnc	.L046xts_enc_loop6
	movl	240(%ebp),%ecx
	movl	%ebp,%edx
	movl	%ecx,%ebx
.L045xts_enc_short:
	addl	$96,%eax
	jz	.L047xts_enc_done6x
	movdqa	%xmm1,%xmm5
	cmpl	$32,%eax
	jb	.L048xts_enc_one
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	je	.L049xts_enc_two
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,%xmm6
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	cmpl	$64,%eax
	jb	.L050xts_enc_three
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,%xmm7
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	movdqa	%xmm5,(%esp)
	movdqa	%xmm6,16(%esp)
	je	.L051xts_enc_four
	movdqa	%xmm7,32(%esp)
	pshufd	$19,%xmm0,%xmm7
	movdqa	%xmm1,48(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm7
	pxor	%xmm1,%xmm7
	movdqu	(%esi),%xmm2
	movdqu	16(%esi),%xmm3
	movdqu	32(%esi),%xmm4
	pxor	(%esp),%xmm2
	movdqu	48(%esi),%xmm5
	pxor	16(%esp),%xmm3
	movdqu	64(%esi),%xmm6
	pxor	32(%esp),%xmm4
	leal	80(%esi),%esi
	pxor	48(%esp),%xmm5
	movdqa	%xmm7,64(%esp)
	pxor	%xmm7,%xmm6
	call	__aesni_encrypt6
	movaps	64(%esp),%xmm1
	xorps	(%esp),%xmm2
	xorps	16(%esp),%xmm3
	xorps	32(%esp),%xmm4
	movups	%xmm2,(%edi)
	xorps	48(%esp),%xmm5
	movups	%xmm3,16(%edi)
	xorps	%xmm1,%xmm6
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	leal	80(%edi),%edi
	jmp	.L052xts_enc_done
.align	16
.L048xts_enc_one:
	movups	(%esi),%xmm2
	leal	16(%esi),%esi
	xorps	%xmm5,%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L053enc1_loop_9:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L053enc1_loop_9
.byte	102,15,56,221,209
	xorps	%xmm5,%xmm2
	movups	%xmm2,(%edi)
	leal	16(%edi),%edi
	movdqa	%xmm5,%xmm1
	jmp	.L052xts_enc_done
.align	16
.L049xts_enc_two:
	movaps	%xmm1,%xmm6
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	leal	32(%esi),%esi
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	call	__aesni_encrypt2
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	leal	32(%edi),%edi
	movdqa	%xmm6,%xmm1
	jmp	.L052xts_enc_done
.align	16
.L050xts_enc_three:
	movaps	%xmm1,%xmm7
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	movups	32(%esi),%xmm4
	leal	48(%esi),%esi
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	xorps	%xmm7,%xmm4
	call	__aesni_encrypt3
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	xorps	%xmm7,%xmm4
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	leal	48(%edi),%edi
	movdqa	%xmm7,%xmm1
	jmp	.L052xts_enc_done
.align	16
.L051xts_enc_four:
	movaps	%xmm1,%xmm6
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	movups	32(%esi),%xmm4
	xorps	(%esp),%xmm2
	movups	48(%esi),%xmm5
	leal	64(%esi),%esi
	xorps	16(%esp),%xmm3
	xorps	%xmm7,%xmm4
	xorps	%xmm6,%xmm5
	call	__aesni_encrypt4
	xorps	(%esp),%xmm2
	xorps	16(%esp),%xmm3
	xorps	%xmm7,%xmm4
	movups	%xmm2,(%edi)
	xorps	%xmm6,%xmm5
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	leal	64(%edi),%edi
	movdqa	%xmm6,%xmm1
	jmp	.L052xts_enc_done
.align	16
.L047xts_enc_done6x:
	movl	112(%esp),%eax
	andl	$15,%eax
	jz	.L054xts_enc_ret
	movdqa	%xmm1,%xmm5
	movl	%eax,112(%esp)
	jmp	.L055xts_enc_steal
.align	16
.L052xts_enc_done:
	movl	112(%esp),%eax
	pxor	%xmm0,%xmm0
	andl	$15,%eax
	jz	.L054xts_enc_ret
	pcmpgtd	%xmm1,%xmm0
	movl	%eax,112(%esp)
	pshufd	$19,%xmm0,%xmm5
	paddq	%xmm1,%xmm1
	pand	96(%esp),%xmm5
	pxor	%xmm1,%xmm5
.L055xts_enc_steal:
	movzbl	(%esi),%ecx
	movzbl	-16(%edi),%edx
	leal	1(%esi),%esi
	movb	%cl,-16(%edi)
	movb	%dl,(%edi)
	leal	1(%edi),%edi
	subl	$1,%eax
	jnz	.L055xts_enc_steal
	subl	112(%esp),%edi
	movl	%ebp,%edx
	movl	%ebx,%ecx
	movups	-16(%edi),%xmm2
	xorps	%xmm5,%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L056enc1_loop_10:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L056enc1_loop_10
.byte	102,15,56,221,209
	xorps	%xmm5,%xmm2
	movups	%xmm2,-16(%edi)
.L054xts_enc_ret:
	movl	116(%esp),%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_xts_decrypt
.def	_aesni_xts_decrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_xts_decrypt:
.L_aesni_xts_decrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	36(%esp),%edx
	movl	40(%esp),%esi
	movl	240(%edx),%ecx
	movups	(%esi),%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L057enc1_loop_11:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L057enc1_loop_11
.byte	102,15,56,221,209
	movl	20(%esp),%esi
	movl	24(%esp),%edi
	movl	28(%esp),%eax
	movl	32(%esp),%edx
	movl	%esp,%ebp
	subl	$120,%esp
	andl	$-16,%esp
	xorl	%ebx,%ebx
	testl	$15,%eax
	setnz	%bl
	shll	$4,%ebx
	subl	%ebx,%eax
	movl	$135,96(%esp)
	movl	$0,100(%esp)
	movl	$1,104(%esp)
	movl	$0,108(%esp)
	movl	%eax,112(%esp)
	movl	%ebp,116(%esp)
	movl	240(%edx),%ecx
	movl	%edx,%ebp
	movl	%ecx,%ebx
	movdqa	%xmm2,%xmm1
	pxor	%xmm0,%xmm0
	movdqa	96(%esp),%xmm3
	pcmpgtd	%xmm1,%xmm0
	andl	$-16,%eax
	subl	$96,%eax
	jc	.L058xts_dec_short
	shll	$4,%ecx
	movl	$16,%ebx
	subl	%ecx,%ebx
	leal	32(%edx,%ecx,1),%edx
	jmp	.L059xts_dec_loop6
.align	16
.L059xts_dec_loop6:
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,16(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,32(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,48(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	pshufd	$19,%xmm0,%xmm7
	movdqa	%xmm1,64(%esp)
	paddq	%xmm1,%xmm1
	movups	(%ebp),%xmm0
	pand	%xmm3,%xmm7
	movups	(%esi),%xmm2
	pxor	%xmm1,%xmm7
	movl	%ebx,%ecx
	movdqu	16(%esi),%xmm3
	xorps	%xmm0,%xmm2
	movdqu	32(%esi),%xmm4
	pxor	%xmm0,%xmm3
	movdqu	48(%esi),%xmm5
	pxor	%xmm0,%xmm4
	movdqu	64(%esi),%xmm6
	pxor	%xmm0,%xmm5
	movdqu	80(%esi),%xmm1
	pxor	%xmm0,%xmm6
	leal	96(%esi),%esi
	pxor	(%esp),%xmm2
	movdqa	%xmm7,80(%esp)
	pxor	%xmm1,%xmm7
	movups	16(%ebp),%xmm1
	pxor	16(%esp),%xmm3
	pxor	32(%esp),%xmm4
.byte	102,15,56,222,209
	pxor	48(%esp),%xmm5
	pxor	64(%esp),%xmm6
.byte	102,15,56,222,217
	pxor	%xmm0,%xmm7
	movups	32(%ebp),%xmm0
.byte	102,15,56,222,225
.byte	102,15,56,222,233
.byte	102,15,56,222,241
.byte	102,15,56,222,249
	call	.L_aesni_decrypt6_enter
	movdqa	80(%esp),%xmm1
	pxor	%xmm0,%xmm0
	xorps	(%esp),%xmm2
	pcmpgtd	%xmm1,%xmm0
	xorps	16(%esp),%xmm3
	movups	%xmm2,(%edi)
	xorps	32(%esp),%xmm4
	movups	%xmm3,16(%edi)
	xorps	48(%esp),%xmm5
	movups	%xmm4,32(%edi)
	xorps	64(%esp),%xmm6
	movups	%xmm5,48(%edi)
	xorps	%xmm1,%xmm7
	movups	%xmm6,64(%edi)
	pshufd	$19,%xmm0,%xmm2
	movups	%xmm7,80(%edi)
	leal	96(%edi),%edi
	movdqa	96(%esp),%xmm3
	pxor	%xmm0,%xmm0
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	subl	$96,%eax
	jnc	.L059xts_dec_loop6
	movl	240(%ebp),%ecx
	movl	%ebp,%edx
	movl	%ecx,%ebx
.L058xts_dec_short:
	addl	$96,%eax
	jz	.L060xts_dec_done6x
	movdqa	%xmm1,%xmm5
	cmpl	$32,%eax
	jb	.L061xts_dec_one
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	je	.L062xts_dec_two
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,%xmm6
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	cmpl	$64,%eax
	jb	.L063xts_dec_three
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	%xmm1,%xmm7
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
	movdqa	%xmm5,(%esp)
	movdqa	%xmm6,16(%esp)
	je	.L064xts_dec_four
	movdqa	%xmm7,32(%esp)
	pshufd	$19,%xmm0,%xmm7
	movdqa	%xmm1,48(%esp)
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm7
	pxor	%xmm1,%xmm7
	movdqu	(%esi),%xmm2
	movdqu	16(%esi),%xmm3
	movdqu	32(%esi),%xmm4
	pxor	(%esp),%xmm2
	movdqu	48(%esi),%xmm5
	pxor	16(%esp),%xmm3
	movdqu	64(%esi),%xmm6
	pxor	32(%esp),%xmm4
	leal	80(%esi),%esi
	pxor	48(%esp),%xmm5
	movdqa	%xmm7,64(%esp)
	pxor	%xmm7,%xmm6
	call	__aesni_decrypt6
	movaps	64(%esp),%xmm1
	xorps	(%esp),%xmm2
	xorps	16(%esp),%xmm3
	xorps	32(%esp),%xmm4
	movups	%xmm2,(%edi)
	xorps	48(%esp),%xmm5
	movups	%xmm3,16(%edi)
	xorps	%xmm1,%xmm6
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	movups	%xmm6,64(%edi)
	leal	80(%edi),%edi
	jmp	.L065xts_dec_done
.align	16
.L061xts_dec_one:
	movups	(%esi),%xmm2
	leal	16(%esi),%esi
	xorps	%xmm5,%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L066dec1_loop_12:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L066dec1_loop_12
.byte	102,15,56,223,209
	xorps	%xmm5,%xmm2
	movups	%xmm2,(%edi)
	leal	16(%edi),%edi
	movdqa	%xmm5,%xmm1
	jmp	.L065xts_dec_done
.align	16
.L062xts_dec_two:
	movaps	%xmm1,%xmm6
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	leal	32(%esi),%esi
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	call	__aesni_decrypt2
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	leal	32(%edi),%edi
	movdqa	%xmm6,%xmm1
	jmp	.L065xts_dec_done
.align	16
.L063xts_dec_three:
	movaps	%xmm1,%xmm7
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	movups	32(%esi),%xmm4
	leal	48(%esi),%esi
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	xorps	%xmm7,%xmm4
	call	__aesni_decrypt3
	xorps	%xmm5,%xmm2
	xorps	%xmm6,%xmm3
	xorps	%xmm7,%xmm4
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	leal	48(%edi),%edi
	movdqa	%xmm7,%xmm1
	jmp	.L065xts_dec_done
.align	16
.L064xts_dec_four:
	movaps	%xmm1,%xmm6
	movups	(%esi),%xmm2
	movups	16(%esi),%xmm3
	movups	32(%esi),%xmm4
	xorps	(%esp),%xmm2
	movups	48(%esi),%xmm5
	leal	64(%esi),%esi
	xorps	16(%esp),%xmm3
	xorps	%xmm7,%xmm4
	xorps	%xmm6,%xmm5
	call	__aesni_decrypt4
	xorps	(%esp),%xmm2
	xorps	16(%esp),%xmm3
	xorps	%xmm7,%xmm4
	movups	%xmm2,(%edi)
	xorps	%xmm6,%xmm5
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	leal	64(%edi),%edi
	movdqa	%xmm6,%xmm1
	jmp	.L065xts_dec_done
.align	16
.L060xts_dec_done6x:
	movl	112(%esp),%eax
	andl	$15,%eax
	jz	.L067xts_dec_ret
	movl	%eax,112(%esp)
	jmp	.L068xts_dec_only_one_more
.align	16
.L065xts_dec_done:
	movl	112(%esp),%eax
	pxor	%xmm0,%xmm0
	andl	$15,%eax
	jz	.L067xts_dec_ret
	pcmpgtd	%xmm1,%xmm0
	movl	%eax,112(%esp)
	pshufd	$19,%xmm0,%xmm2
	pxor	%xmm0,%xmm0
	movdqa	96(%esp),%xmm3
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm2
	pcmpgtd	%xmm1,%xmm0
	pxor	%xmm2,%xmm1
.L068xts_dec_only_one_more:
	pshufd	$19,%xmm0,%xmm5
	movdqa	%xmm1,%xmm6
	paddq	%xmm1,%xmm1
	pand	%xmm3,%xmm5
	pxor	%xmm1,%xmm5
	movl	%ebp,%edx
	movl	%ebx,%ecx
	movups	(%esi),%xmm2
	xorps	%xmm5,%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L069dec1_loop_13:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L069dec1_loop_13
.byte	102,15,56,223,209
	xorps	%xmm5,%xmm2
	movups	%xmm2,(%edi)
.L070xts_dec_steal:
	movzbl	16(%esi),%ecx
	movzbl	(%edi),%edx
	leal	1(%esi),%esi
	movb	%cl,(%edi)
	movb	%dl,16(%edi)
	leal	1(%edi),%edi
	subl	$1,%eax
	jnz	.L070xts_dec_steal
	subl	112(%esp),%edi
	movl	%ebp,%edx
	movl	%ebx,%ecx
	movups	(%edi),%xmm2
	xorps	%xmm6,%xmm2
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L071dec1_loop_14:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L071dec1_loop_14
.byte	102,15,56,223,209
	xorps	%xmm6,%xmm2
	movups	%xmm2,(%edi)
.L067xts_dec_ret:
	movl	116(%esp),%esp
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.globl	_aesni_cbc_encrypt
.def	_aesni_cbc_encrypt;	.scl	2;	.type	32;	.endef
.align	16
_aesni_cbc_encrypt:
.L_aesni_cbc_encrypt_begin:
	pushl	%ebp
	pushl	%ebx
	pushl	%esi
	pushl	%edi
	movl	20(%esp),%esi
	movl	%esp,%ebx
	movl	24(%esp),%edi
	subl	$24,%ebx
	movl	28(%esp),%eax
	andl	$-16,%ebx
	movl	32(%esp),%edx
	movl	36(%esp),%ebp
	testl	%eax,%eax
	jz	.L072cbc_abort
	cmpl	$0,40(%esp)
	xchgl	%esp,%ebx
	movups	(%ebp),%xmm7
	movl	240(%edx),%ecx
	movl	%edx,%ebp
	movl	%ebx,16(%esp)
	movl	%ecx,%ebx
	je	.L073cbc_decrypt
	movaps	%xmm7,%xmm2
	cmpl	$16,%eax
	jb	.L074cbc_enc_tail
	subl	$16,%eax
	jmp	.L075cbc_enc_loop
.align	16
.L075cbc_enc_loop:
	movups	(%esi),%xmm7
	leal	16(%esi),%esi
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	xorps	%xmm0,%xmm7
	leal	32(%edx),%edx
	xorps	%xmm7,%xmm2
.L076enc1_loop_15:
.byte	102,15,56,220,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L076enc1_loop_15
.byte	102,15,56,221,209
	movl	%ebx,%ecx
	movl	%ebp,%edx
	movups	%xmm2,(%edi)
	leal	16(%edi),%edi
	subl	$16,%eax
	jnc	.L075cbc_enc_loop
	addl	$16,%eax
	jnz	.L074cbc_enc_tail
	movaps	%xmm2,%xmm7
	jmp	.L077cbc_ret
.L074cbc_enc_tail:
	movl	%eax,%ecx
.long	2767451785
	movl	$16,%ecx
	subl	%eax,%ecx
	xorl	%eax,%eax
.long	2868115081
	leal	-16(%edi),%edi
	movl	%ebx,%ecx
	movl	%edi,%esi
	movl	%ebp,%edx
	jmp	.L075cbc_enc_loop
.align	16
.L073cbc_decrypt:
	cmpl	$80,%eax
	jbe	.L078cbc_dec_tail
	movaps	%xmm7,(%esp)
	subl	$80,%eax
	jmp	.L079cbc_dec_loop6_enter
.align	16
.L080cbc_dec_loop6:
	movaps	%xmm0,(%esp)
	movups	%xmm7,(%edi)
	leal	16(%edi),%edi
.L079cbc_dec_loop6_enter:
	movdqu	(%esi),%xmm2
	movdqu	16(%esi),%xmm3
	movdqu	32(%esi),%xmm4
	movdqu	48(%esi),%xmm5
	movdqu	64(%esi),%xmm6
	movdqu	80(%esi),%xmm7
	call	__aesni_decrypt6
	movups	(%esi),%xmm1
	movups	16(%esi),%xmm0
	xorps	(%esp),%xmm2
	xorps	%xmm1,%xmm3
	movups	32(%esi),%xmm1
	xorps	%xmm0,%xmm4
	movups	48(%esi),%xmm0
	xorps	%xmm1,%xmm5
	movups	64(%esi),%xmm1
	xorps	%xmm0,%xmm6
	movups	80(%esi),%xmm0
	xorps	%xmm1,%xmm7
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	leal	96(%esi),%esi
	movups	%xmm4,32(%edi)
	movl	%ebx,%ecx
	movups	%xmm5,48(%edi)
	movl	%ebp,%edx
	movups	%xmm6,64(%edi)
	leal	80(%edi),%edi
	subl	$96,%eax
	ja	.L080cbc_dec_loop6
	movaps	%xmm7,%xmm2
	movaps	%xmm0,%xmm7
	addl	$80,%eax
	jle	.L081cbc_dec_tail_collected
	movups	%xmm2,(%edi)
	leal	16(%edi),%edi
.L078cbc_dec_tail:
	movups	(%esi),%xmm2
	movaps	%xmm2,%xmm6
	cmpl	$16,%eax
	jbe	.L082cbc_dec_one
	movups	16(%esi),%xmm3
	movaps	%xmm3,%xmm5
	cmpl	$32,%eax
	jbe	.L083cbc_dec_two
	movups	32(%esi),%xmm4
	cmpl	$48,%eax
	jbe	.L084cbc_dec_three
	movups	48(%esi),%xmm5
	cmpl	$64,%eax
	jbe	.L085cbc_dec_four
	movups	64(%esi),%xmm6
	movaps	%xmm7,(%esp)
	movups	(%esi),%xmm2
	xorps	%xmm7,%xmm7
	call	__aesni_decrypt6
	movups	(%esi),%xmm1
	movups	16(%esi),%xmm0
	xorps	(%esp),%xmm2
	xorps	%xmm1,%xmm3
	movups	32(%esi),%xmm1
	xorps	%xmm0,%xmm4
	movups	48(%esi),%xmm0
	xorps	%xmm1,%xmm5
	movups	64(%esi),%xmm7
	xorps	%xmm0,%xmm6
	movups	%xmm2,(%edi)
	movups	%xmm3,16(%edi)
	movups	%xmm4,32(%edi)
	movups	%xmm5,48(%edi)
	leal	64(%edi),%edi
	movaps	%xmm6,%xmm2
	subl	$80,%eax
	jmp	.L081cbc_dec_tail_collected
.align	16
.L082cbc_dec_one:
	movups	(%edx),%xmm0
	movups	16(%edx),%xmm1
	leal	32(%edx),%edx
	xorps	%xmm0,%xmm2
.L086dec1_loop_16:
.byte	102,15,56,222,209
	decl	%ecx
	movups	(%edx),%xmm1
	leal	16(%edx),%edx
	jnz	.L086dec1_loop_16
.byte	102,15,56,223,209
	xorps	%xmm7,%xmm2
	movaps	%xmm6,%xmm7
	subl	$16,%eax
	jmp	.L081cbc_dec_tail_collected
.align	16
.L083cbc_dec_two:
	call	__aesni_decrypt2
	xorps	%xmm7,%xmm2
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	movaps	%xmm3,%xmm2
	leal	16(%edi),%edi
	movaps	%xmm5,%xmm7
	subl	$32,%eax
	jmp	.L081cbc_dec_tail_collected
.align	16
.L084cbc_dec_three:
	call	__aesni_decrypt3
	xorps	%xmm7,%xmm2
	xorps	%xmm6,%xmm3
	xorps	%xmm5,%xmm4
	movups	%xmm2,(%edi)
	movaps	%xmm4,%xmm2
	movups	%xmm3,16(%edi)
	leal	32(%edi),%edi
	movups	32(%esi),%xmm7
	subl	$48,%eax
	jmp	.L081cbc_dec_tail_collected
.align	16
.L085cbc_dec_four:
	call	__aesni_decrypt4
	movups	16(%esi),%xmm1
	movups	32(%esi),%xmm0
	xorps	%xmm7,%xmm2
	movups	48(%esi),%xmm7
	xorps	%xmm6,%xmm3
	movups	%xmm2,(%edi)
	xorps	%xmm1,%xmm4
	movups	%xmm3,16(%edi)
	xorps	%xmm0,%xmm5
	movups	%xmm4,32(%edi)
	leal	48(%edi),%edi
	movaps	%xmm5,%xmm2
	subl	$64,%eax
.L081cbc_dec_tail_collected:
	andl	$15,%eax
	jnz	.L087cbc_dec_tail_partial
	movups	%xmm2,(%edi)
	jmp	.L077cbc_ret
.align	16
.L087cbc_dec_tail_partial:
	movaps	%xmm2,(%esp)
	movl	$16,%ecx
	movl	%esp,%esi
	subl	%eax,%ecx
.long	2767451785
.L077cbc_ret:
	movl	16(%esp),%esp
	movl	36(%esp),%ebp
	movups	%xmm7,(%ebp)
.L072cbc_abort:
	popl	%edi
	popl	%esi
	popl	%ebx
	popl	%ebp
	ret
.def	__aesni_set_encrypt_key;	.scl	3;	.type	32;	.endef
.align	16
__aesni_set_encrypt_key:
	testl	%eax,%eax
	jz	.L088bad_pointer
	testl	%edx,%edx
	jz	.L088bad_pointer
	movups	(%eax),%xmm0
	xorps	%xmm4,%xmm4
	leal	16(%edx),%edx
	cmpl	$256,%ecx
	je	.L08914rounds
	cmpl	$192,%ecx
	je	.L09012rounds
	cmpl	$128,%ecx
	jne	.L091bad_keybits
.align	16
.L09210rounds:
	movl	$9,%ecx
	movups	%xmm0,-16(%edx)
.byte	102,15,58,223,200,1
	call	.L093key_128_cold
.byte	102,15,58,223,200,2
	call	.L094key_128
.byte	102,15,58,223,200,4
	call	.L094key_128
.byte	102,15,58,223,200,8
	call	.L094key_128
.byte	102,15,58,223,200,16
	call	.L094key_128
.byte	102,15,58,223,200,32
	call	.L094key_128
.byte	102,15,58,223,200,64
	call	.L094key_128
.byte	102,15,58,223,200,128
	call	.L094key_128
.byte	102,15,58,223,200,27
	call	.L094key_128
.byte	102,15,58,223,200,54
	call	.L094key_128
	movups	%xmm0,(%edx)
	movl	%ecx,80(%edx)
	xorl	%eax,%eax
	ret
.align	16
.L094key_128:
	movups	%xmm0,(%edx)
	leal	16(%edx),%edx
.L093key_128_cold:
	shufps	$16,%xmm0,%xmm4
	xorps	%xmm4,%xmm0
	shufps	$140,%xmm0,%xmm4
	xorps	%xmm4,%xmm0
	shufps	$255,%xmm1,%xmm1
	xorps	%xmm1,%xmm0
	ret
.align	16
.L09012rounds:
	movq	16(%eax),%xmm2
	movl	$11,%ecx
	movups	%xmm0,-16(%edx)
.byte	102,15,58,223,202,1
	call	.L095key_192a_cold
.byte	102,15,58,223,202,2
	call	.L096key_192b
.byte	102,15,58,223,202,4
	call	.L097key_192a
.byte	102,15,58,223,202,8
	call	.L096key_192b
.byte	102,15,58,223,202,16
	call	.L097key_192a
.byte	102,15,58,223,202,32
	call	.L096key_192b
.byte	102,15,58,223,202,64
	call	.L097key_192a
.byte	102,15,58,223,202,128
	call	.L096key_192b
	movups	%xmm0,(%edx)
	movl	%ecx,48(%edx)
	xorl	%eax,%eax
	ret
.align	16
.L097key_192a:
	movups	%xmm0,(%edx)
	leal	16(%edx),%edx
.align	16
.L095key_192a_cold:
	movaps	%xmm2,%xmm5
.L098key_192b_warm:
	shufps	$16,%xmm0,%xmm4
	movdqa	%xmm2,%xmm3
	xorps	%xmm4,%xmm0
	shufps	$140,%xmm0,%xmm4
	pslldq	$4,%xmm3
	xorps	%xmm4,%xmm0
	pshufd	$85,%xmm1,%xmm1
	pxor	%xmm3,%xmm2
	pxor	%xmm1,%xmm0
	pshufd	$255,%xmm0,%xmm3
	pxor	%xmm3,%xmm2
	ret
.align	16
.L096key_192b:
	movaps	%xmm0,%xmm3
	shufps	$68,%xmm0,%xmm5
	movups	%xmm5,(%edx)
	shufps	$78,%xmm2,%xmm3
	movups	%xmm3,16(%edx)
	leal	32(%edx),%edx
	jmp	.L098key_192b_warm
.align	16
.L08914rounds:
	movups	16(%eax),%xmm2
	movl	$13,%ecx
	leal	16(%edx),%edx
	movups	%xmm0,-32(%edx)
	movups	%xmm2,-16(%edx)
.byte	102,15,58,223,202,1
	call	.L099key_256a_cold
.byte	102,15,58,223,200,1
	call	.L100key_256b
.byte	102,15,58,223,202,2
	call	.L101key_256a
.byte	102,15,58,223,200,2
	call	.L100key_256b
.byte	102,15,58,223,202,4
	call	.L101key_256a
.byte	102,15,58,223,200,4
	call	.L100key_256b
.byte	102,15,58,223,202,8
	call	.L101key_256a
.byte	102,15,58,223,200,8
	call	.L100key_256b
.byte	102,15,58,223,202,16
	call	.L101key_256a
.byte	102,15,58,223,200,16
	call	.L100key_256b
.byte	102,15,58,223,202,32
	call	.L101key_256a
.byte	102,15,58,223,200,32
	call	.L100key_256b
.byte	102,15,58,223,202,64
	call	.L101key_256a
	movups	%xmm0,(%edx)
	movl	%ecx,16(%edx)
	xorl	%eax,%eax
	ret
.align	16
.L101key_256a:
	movups	%xmm2,(%edx)
	leal	16(%edx),%edx
.L099key_256a_cold:
	shufps	$16,%xmm0,%xmm4
	xorps	%xmm4,%xmm0
	shufps	$140,%xmm0,%xmm4
	xorps	%xmm4,%xmm0
	shufps	$255,%xmm1,%xmm1
	xorps	%xmm1,%xmm0
	ret
.align	16
.L100key_256b:
	movups	%xmm0,(%edx)
	leal	16(%edx),%edx
	shufps	$16,%xmm2,%xmm4
	xorps	%xmm4,%xmm2
	shufps	$140,%xmm2,%xmm4
	xorps	%xmm4,%xmm2
	shufps	$170,%xmm1,%xmm1
	xorps	%xmm1,%xmm2
	ret
.align	4
.L088bad_pointer:
	movl	$-1,%eax
	ret
.align	4
.L091bad_keybits:
	movl	$-2,%eax
	ret
.globl	_aesni_set_encrypt_key
.def	_aesni_set_encrypt_key;	.scl	2;	.type	32;	.endef
.align	16
_aesni_set_encrypt_key:
.L_aesni_set_encrypt_key_begin:
	movl	4(%esp),%eax
	movl	8(%esp),%ecx
	movl	12(%esp),%edx
	call	__aesni_set_encrypt_key
	ret
.globl	_aesni_set_decrypt_key
.def	_aesni_set_decrypt_key;	.scl	2;	.type	32;	.endef
.align	16
_aesni_set_decrypt_key:
.L_aesni_set_decrypt_key_begin:
	movl	4(%esp),%eax
	movl	8(%esp),%ecx
	movl	12(%esp),%edx
	call	__aesni_set_encrypt_key
	movl	12(%esp),%edx
	shll	$4,%ecx
	testl	%eax,%eax
	jnz	.L102dec_key_ret
	leal	16(%edx,%ecx,1),%eax
	movups	(%edx),%xmm0
	movups	(%eax),%xmm1
	movups	%xmm0,(%eax)
	movups	%xmm1,(%edx)
	leal	16(%edx),%edx
	leal	-16(%eax),%eax
.L103dec_key_inverse:
	movups	(%edx),%xmm0
	movups	(%eax),%xmm1
.byte	102,15,56,219,192
.byte	102,15,56,219,201
	leal	16(%edx),%edx
	leal	-16(%eax),%eax
	movups	%xmm0,16(%eax)
	movups	%xmm1,-16(%edx)
	cmpl	%edx,%eax
	ja	.L103dec_key_inverse
	movups	(%edx),%xmm0
.byte	102,15,56,219,192
	movups	%xmm0,(%edx)
	xorl	%eax,%eax
.L102dec_key_ret:
	ret
.byte	65,69,83,32,102,111,114,32,73,110,116,101,108,32,65,69
.byte	83,45,78,73,44,32,67,82,89,80,84,79,71,65,77,83
.byte	32,98,121,32,60,97,112,112,114,111,64,111,112,101,110,115
.byte	115,108,46,111,114,103,62,0

