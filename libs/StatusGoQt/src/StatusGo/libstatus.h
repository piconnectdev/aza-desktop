/* Code generated by cmd/cgo; DO NOT EDIT. */

/* package github.com/status-im/status-go/build/bin/statusgo-lib */


#line 1 "cgo-builtin-export-prolog"

#include <stddef.h>

#ifndef GO_CGO_EXPORT_PROLOGUE_H
#define GO_CGO_EXPORT_PROLOGUE_H

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef struct { const char *p; ptrdiff_t n; } _GoString_;
#endif

#endif

/* Start of preamble from import "C" comments.  */


#line 4 "main.go"
 #include <stdlib.h>

#line 1 "cgo-generated-wrapper"


/* End of preamble from import "C" comments.  */


/* Start of boilerplate cgo prologue.  */
#line 1 "cgo-gcc-export-header-prolog"

#ifndef GO_CGO_PROLOGUE_H
#define GO_CGO_PROLOGUE_H

typedef signed char GoInt8;
typedef unsigned char GoUint8;
typedef short GoInt16;
typedef unsigned short GoUint16;
typedef int GoInt32;
typedef unsigned int GoUint32;
typedef long long GoInt64;
typedef unsigned long long GoUint64;
typedef GoInt64 GoInt;
typedef GoUint64 GoUint;
typedef size_t GoUintptr;
typedef float GoFloat32;
typedef double GoFloat64;
#ifdef _MSC_VER
#include <complex.h>
typedef _Fcomplex GoComplex64;
typedef _Dcomplex GoComplex128;
#else
typedef float _Complex GoComplex64;
typedef double _Complex GoComplex128;
#endif

/*
  static assertion to make sure the file is being used on architecture
  at least with matching size of GoInt.
*/
typedef char _check_for_64_bit_pointer_matching_GoInt[sizeof(void*)==64/8 ? 1:-1];

#ifndef GO_CGO_GOSTRING_TYPEDEF
typedef _GoString_ GoString;
#endif
typedef void *GoMap;
typedef void *GoChan;
typedef struct { void *t; void *v; } GoInterface;
typedef struct { void *data; GoInt len; GoInt cap; } GoSlice;

#endif

/* End of boilerplate cgo prologue.  */

#ifdef __cplusplus
extern "C" {
#endif

extern char* SaveAccountAndLoginWithKeycard(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData, char* keyHex);
extern char* LoginWithKeycard(char* accountData, char* password, char* keyHex);
extern void AppStateChange(char* state);
extern char* ConvertToRegularAccount(char* mnemonic, char* currPassword, char* newPassword);
extern char* OpenAccounts(char* datadir);
extern char* VerifyAccountPassword(char* keyStoreDir, char* address, char* password);
extern char* SignMessage(char* rpcParams);
extern char* CallRPC(char* inputJSON);
extern char* StopLocalNotifications();
extern char* ValidateMnemonic(char* mnemonic);
extern char* SerializeLegacyKey(char* key);
extern char* ChangeDatabasePassword(char* KeyUID, char* password, char* newPassword);
extern char* EncodeFunctionCall(char* method, char* paramsJSON);
extern char* ResetChainData();
extern char* InitKeystore(char* keydir);
extern char* Recover(char* rpcParams);
extern char* StartCPUProfile(char* dataDir);
extern char* StopCPUProfiling();
extern char* ExportNodeLogs();
extern char* InputConnectionStringForBootstrappingAnotherDevice(char* cs, char* configJSON);
extern char* IsAddress(char* address);
extern char* DeleteMultiaccount(char* keyUID, char* keyStoreDir);
extern char* MultiformatDeserializePublicKey(char* key, char* outBase);
extern char* InputConnectionStringForBootstrapping(char* cs, char* configJSON);
extern char* SignGroupMembership(char* content);
extern char* VerifyDatabasePassword(char* keyUID, char* password);
extern char* DeleteImportedKey(char* address, char* password, char* keyStoreDir);
extern void ConnectionChange(char* typ, int expensive);
extern char* EmojiHash(char* pk);
extern char* SendTransactionWithChainID(int chainID, char* txArgsJSON, char* password);
extern char* SendTransaction(char* txArgsJSON, char* password);
extern char* MultiformatSerializePublicKey(char* key, char* outBase);
extern char* SwitchFleet(char* fleet, char* configJSON);
extern char* Utf8ToHex(char* str);
extern char* CheckAddressChecksum(char* address);
extern char* GetNodeConfig();
extern char* CreateAccountAndLogin(char* requestJSON);
extern char* SendTransactionWithSignature(char* txArgsJSON, char* sigString);
extern char* GenerateAlias(char* pk);
extern char* DecompressPublicKey(char* key);
extern char* ExtractGroupMembershipSignatures(char* signaturePairsStr);
extern char* Login(char* accountData, char* password);
extern char* LoginWithConfig(char* accountData, char* password, char* configJSON);
extern char* HashTypedData(char* data);
extern char* HashTypedDataV4(char* data);
extern char* ValidateConnectionString(char* cs);
extern char* SaveAccountAndLogin(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData);
extern char* StartLocalNotifications();
extern char* GenerateImages(char* filepath, int aX, int aY, int bX, int bY);
extern char* HexToUtf8(char* hexString);
extern char* DecodeParameters(char* decodeParamJSON);
extern char* SignTypedData(char* data, char* address, char* password);
extern char* AddPeer(char* enode);
extern char* SignHash(char* hexEncodedHash);
extern char* ColorID(char* pk);
extern char* ConvertToKeycardAccount(char* accountData, char* settingsJSON, char* keycardUID, char* password, char* newPassword);
extern char* ImageServerTLSCert();
extern char* GetConnectionStringForBootstrappingAnotherDevice(char* configJSON);
extern char* CallPrivateRPC(char* inputJSON);
extern char* MigrateKeyStoreDir(char* accountData, char* password, char* oldDir, char* newDir);
extern void SetSignalEventCallback(void* cb);
extern char* HexToNumber(char* hex);
extern char* Logout();
extern char* WriteHeapProfile(char* dataDir);
extern char* CompressPublicKey(char* key);
extern char* ExportUnencryptedDatabase(char* accountData, char* password, char* databasePath);
extern char* GetPasswordStrengthScore(char* paramsJSON);
extern char* GetConnectionStringForBeingBootstrapped(char* configJSON);
extern char* DeserializeAndCompressKey(char* DesktopKey);
extern char* ValidateNodeConfig(char* configJSON);
extern char* SignTypedDataV4(char* data, char* address, char* password);
extern char* ColorHash(char* pk);
extern char* ImportUnencryptedDatabase(char* accountData, char* password, char* databasePath);
extern char* Sha3(char* str);
extern char* ToChecksumAddress(char* address);
extern char* RestoreAccountAndLogin(char* requestJSON);
extern char* IsAlias(char* value);
extern char* Identicon(char* pk);
extern char* GetPasswordStrength(char* paramsJSON);
extern char* StartSearchForLocalPairingPeers();
extern char* EncodeTransfer(char* to, char* value);
extern char* NumberToHex(char* numString);
extern char* HashTransaction(char* txArgsJSON);
extern char* HashMessage(char* message);
extern char* MultiAccountImportPrivateKey(char* paramsJSON);
extern char* MultiAccountStoreDerivedAccounts(char* paramsJSON);
extern char* CreateAccountFromPrivateKey(char* paramsJSON);
extern char* MultiAccountGenerateAndDeriveAddresses(char* paramsJSON);
extern char* MultiAccountDeriveAddresses(char* paramsJSON);
extern char* MultiAccountLoadAccount(char* paramsJSON);
extern char* MultiAccountReset();
extern char* MultiAccountImportMnemonic(char* paramsJSON);
extern char* MultiAccountStoreAccount(char* paramsJSON);
extern char* MultiAccountGenerate(char* paramsJSON);
extern char* CreateAccountFromMnemonicAndDeriveAccountsForPaths(char* paramsJSON);
extern void Free(void* param);

#ifdef __cplusplus
}
#endif
