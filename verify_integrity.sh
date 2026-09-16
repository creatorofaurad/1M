#!/usr/bin/env bash
# Automated SHA-256 Cryptographic Integrity Attestation Verifier
set -e

echo "================================================================="
echo " Verifying Cryptographic SHA-256 Hashes for 1M Master Monographs "
echo "================================================================="

CHECKSUM_FILE="$(mktemp)"

cat << 'EOF' > "$CHECKSUM_FILE"
1b1c26509c24c52c55e760bc7bb03ff8cc606407d4207eee600b83a8768bb161  papers/Srijan_Mandal_P_vs_NP_Final_Publication_Paper.pdf
02a1c0ad47c1a20ea8c3b55b69d056507f6aed56cbd76423a436ab5a1c8a60ff  papers/Srijan_Mandal_Hardened_Master_Monograph_P_neq_NP.pdf
0a6f7b6251d38e2682554b99d8e0c14c9fdc782915df8a27976bbcc90a1b6c5b  papers/Srijan_Mandal_NonMonotone_Circuit_Lifting_Proof.pdf
6ad711aa0332f53f2def45d609603b4864f49b582863d0f72703fd14887977ec  papers/Srijan_Mandal_2Systole_Coboundary_Resolution_Proof.pdf
34d58494ace4962035c5f2f98b375db6a4dd51b387e99f736e2f2068a3664b19  papers/monograph_core/Srijan_Mandal_100Page_Master_Monograph.pdf
d691a61715b1fe6666dd537d491b454b9af3993c175986099a5a75c9d5c19a76  papers/FINAL_MASTER_PAPER_P_NEQ_NP.tex
8455568155815e58851169f38675e67bd70602f02a6f6b008f5c85d523a57447  papers/HARDENED_MASTER_MONOGRAPH_P_NEQ_NP.tex
4eb20ecfbabef85791db813ab0e039259b5b602ff1bba1ed492154808f942ee2  papers/NON_MONOTONE_CIRCUIT_LIFTING_PROOF.tex
5a475682bdffb68d76d948ac2ebabcab0144a9fa866cb607129a591e95cd03d6  papers/SYSTOLE_COBOUNDARY_RESOLUTION_PROOF.tex
137edadea79b948d6d8668634ca377fd420cec1e0641abf08663771b25ac726a  papers/monograph_core/master_monograph.tex
EOF

if command -v sha256sum >/dev/null 2>&1; then
    sha256sum -c "$CHECKSUM_FILE"
elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 -c "$CHECKSUM_FILE"
else
    echo "Error: Neither sha256sum nor shasum found."
    exit 1
fi

rm -f "$CHECKSUM_FILE"
echo "================================================================="
echo " [SUCCESS] All publication monographs and sources verified 100%."
echo "================================================================="
