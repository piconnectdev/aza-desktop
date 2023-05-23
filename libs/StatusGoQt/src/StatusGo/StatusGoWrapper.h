#pragma once

namespace Status::StatusGo
{
    class StatusGoWrapper
    {
    public:
        static char* InitKeystore(char* keydir);
        static char* DeleteMultiaccount(char* keyUID, char* keyStoreDir);
        static char* MultiAccountGenerateAndDeriveAddresses(char* paramsJSON);
        static char* MultiAccountStoreDerivedAccounts(char* paramsJSON);
        static char* MultiAccountStoreAccount(char* paramsJSON);
        static char* GenerateAlias(char* pk);
        static char* SaveAccountAndLogin(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData);
        static char* OpenAccounts(char* datadir);
        static char* Login(char* accountData, char* password);
        static char* LoginWithConfig(char* accountData, char* password, char* configJSON);
        static char* Logout();
        static void SetSignalEventCallback(void* cb);
        static char* CallPrivateRPC(char* inputJSON);

        // NOT USE
        /*
        static char* SaveAccountAndLoginWithKeycard(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData, char* keyHex);
        static char* LoginWithKeycard(char* accountData, char* password, char* keyHex);
        static void AppStateChange(char* state);
        static char* ConvertToRegularAccount(char* mnemonic, char* currPassword, char* newPassword);
        static char* VerifyAccountPassword(char* keyStoreDir, char* address, char* password);
        static char* SignMessage(char* rpcParams);
        static char* CallRPC(char* inputJSON);
        static char* StopLocalNotifications();
        static char* ValidateMnemonic(char* mnemonic);
        static char* SerializeLegacyKey(char* key);
        static char* ChangeDatabasePassword(char* KeyUID, char* password, char* newPassword);
        static char* EncodeFunctionCall(char* method, char* paramsJSON);
        static char* ResetChainData();
        static char* Recover(char* rpcParams);
        static char* StartCPUProfile(char* dataDir);
        static char* StopCPUProfiling();
        static char* ExportNodeLogs();
        static char* InputConnectionStringForBootstrappingAnotherDevice(char* cs, char* configJSON);
        static char* IsAddress(char* address);
        static char* MultiformatDeserializePublicKey(char* key, char* outBase);
        static char* InputConnectionStringForBootstrapping(char* cs, char* configJSON);
        static char* SignGroupMembership(char* content);
        static char* VerifyDatabasePassword(char* keyUID, char* password);
        static char* DeleteImportedKey(char* address, char* password, char* keyStoreDir);
        static void ConnectionChange(char* typ, int expensive);
        static char* EmojiHash(char* pk);
        static char* SendTransactionWithChainID(int chainID, char* txArgsJSON, char* password);
        static char* SendTransaction(char* txArgsJSON, char* password);
        static char* MultiformatSerializePublicKey(char* key, char* outBase);
        static char* SwitchFleet(char* fleet, char* configJSON);
        static char* Utf8ToHex(char* str);
        static char* CheckAddressChecksum(char* address);
        static char* GetNodeConfig();
        static char* CreateAccountAndLogin(char* requestJSON);
        static char* SendTransactionWithSignature(char* txArgsJSON, char* sigString);
        static char* DecompressPublicKey(char* key);
        static char* ExtractGroupMembershipSignatures(char* signaturePairsStr);
        static char* HashTypedData(char* data);
        static char* HashTypedDataV4(char* data);
        static char* ValidateConnectionString(char* cs);
        static char* StartLocalNotifications();
        static char* GenerateImages(char* filepath, int aX, int aY, int bX, int bY);
        static char* HexToUtf8(char* hexString);
        static char* DecodeParameters(char* decodeParamJSON);
        static char* SignTypedData(char* data, char* address, char* password);
        static char* AddPeer(char* enode);
        static char* SignHash(char* hexEncodedHash);
        static char* ColorID(char* pk);
        static char* ConvertToKeycardAccount(char* accountData, char* settingsJSON, char* keycardUID, char* password, char* newPassword);
        static char* ImageServerTLSCert();
        static char* GetConnectionStringForBootstrappingAnotherDevice(char* configJSON);
        static char* MigrateKeyStoreDir(char* accountData, char* password, char* oldDir, char* newDir);
        static char* HexToNumber(char* hex);
        static char* WriteHeapProfile(char* dataDir);
        static char* CompressPublicKey(char* key);
        static char* ExportUnencryptedDatabase(char* accountData, char* password, char* databasePath);
        static char* GetPasswordStrengthScore(char* paramsJSON);
        static char* GetConnectionStringForBeingBootstrapped(char* configJSON);
        static char* DeserializeAndCompressKey(char* DesktopKey);
        static char* ValidateNodeConfig(char* configJSON);
        static char* SignTypedDataV4(char* data, char* address, char* password);
        static char* ColorHash(char* pk);
        static char* ImportUnencryptedDatabase(char* accountData, char* password, char* databasePath);
        static char* Sha3(char* str);
        static char* ToChecksumAddress(char* address);
        static char* RestoreAccountAndLogin(char* requestJSON);
        static char* IsAlias(char* value);
        static char* Identicon(char* pk);
        static char* GetPasswordStrength(char* paramsJSON);
        static char* StartSearchForLocalPairingPeers();
        static char* EncodeTransfer(char* to, char* value);
        static char* NumberToHex(char* numString);
        static char* HashTransaction(char* txArgsJSON);
        static char* HashMessage(char* message);
        static char* MultiAccountImportPrivateKey(char* paramsJSON);
        static char* CreateAccountFromPrivateKey(char* paramsJSON);
        static char* MultiAccountDeriveAddresses(char* paramsJSON);
        static char* MultiAccountLoadAccount(char* paramsJSON);
        static char* MultiAccountReset();
        static char* MultiAccountImportMnemonic(char* paramsJSON);
        static char* MultiAccountGenerate(char* paramsJSON);
        static char* CreateAccountFromMnemonicAndDeriveAccountsForPaths(char* paramsJSON);
        static void Free(void* param);
        */
    };

} // namespace Status::StatusGo
