#include "StatusGoWrapper.h"
#include <libstatus.h>

namespace Status::StatusGo
{
    char* StatusGoWrapper::InitKeystore(char* keydir)
    {
        // QJsonObject
        return "{}";
        //return ::InitKeystore(keydir);
    }
    char* StatusGoWrapper::DeleteMultiaccount(char* keyUID, char* keyStoreDir)
    {
        // QJsonObject
        return "{}";
        //return ::DeleteMultiaccount(keyUID, keyStoreDir);
    }
    char* StatusGoWrapper::MultiAccountGenerateAndDeriveAddresses(char* paramsJSON)
    {
        //QJsonArray
        return "[]";
        //return ::MultiAccountGenerateAndDeriveAddresses(paramsJSON);
    }
    char* StatusGoWrapper::MultiAccountStoreDerivedAccounts(char* paramsJSON)
    {
        // QJsonObject
        return "{}";
        //return ::MultiAccountStoreDerivedAccounts(paramsJSON);
    }
    char* StatusGoWrapper::MultiAccountStoreAccount(char* paramsJSON)
    {
        // QJsonObject
        return "{}";
        //return ::MultiAccountStoreAccount(paramsJSON);
    }
    char* StatusGoWrapper::GenerateAlias(char* pk)
    {
        // QString
        return "abcd";
        //return ::GenerateAlias(pk);
    }
    char* StatusGoWrapper::SaveAccountAndLogin(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData)
    {
        // QJsonObject
        return "{}";
        //return ::SaveAccountAndLogin(accountData, password, settingsJSON, configJSON, subaccountData);
    }
    char* StatusGoWrapper::OpenAccounts(char* datadir)
    {
        // QJsonObject
        return "{}";
        //return ::OpenAccounts(datadir);
    }
    char* StatusGoWrapper::Login(char* accountData, char* password)
    {
        // QJsonObject
        return "{}";
        //return ::Login(accountData, password);
    }
    char* StatusGoWrapper::LoginWithConfig(char* accountData, char* password, char* configJSON)
    {
        // QJsonObject
        return "{}";
        //return ::LoginWithConfig(accountData, password, configJSON);
    }
    char* StatusGoWrapper::Logout()
    {
        // QJsonObject
        return "{}";
        //return ::Logout();
    }
    void StatusGoWrapper::SetSignalEventCallback(void* cb)
    {
        return;
        //return ::SetSignalEventCallback(cb);
    }

    char* StatusGoWrapper::CallPrivateRPC(char* inputJSON)
    {
        return "{}";
        //return ::CallPrivateRPC(inputJSON);
    }

    // NOT USE
    /*
    char* StatusGoWrapper::MultiAccountGenerate(char* paramsJSON)
    {
        return ::MultiAccountGenerate(paramsJSON);
    }
    char* StatusGoWrapper::SaveAccountAndLoginWithKeycard(char* accountData, char* password, char* settingsJSON, char* configJSON, char* subaccountData, char* keyHex)
    {
        return ::SaveAccountAndLoginWithKeycard(accountData, password, settingsJSON, configJSON, subaccountData, keyHex);
    }
    char* StatusGoWrapper::LoginWithKeycard(char* accountData, char* password, char* keyHex)
    {
        return ::LoginWithKeycard(accountData, password, keyHex);
    }
    void StatusGoWrapper::AppStateChange(char* state)
    {
        ::AppStateChange(state);
    }
    char* StatusGoWrapper::ConvertToRegularAccount(char* mnemonic, char* currPassword, char* newPassword)
    {
        return ::ConvertToRegularAccount(mnemonic, currPassword, newPassword);
    }
    char* StatusGoWrapper::VerifyAccountPassword(char* keyStoreDir, char* address, char* password)
    {
        return ::VerifyAccountPassword(keyStoreDir, address, password);
    }
    char* StatusGoWrapper::SignMessage(char* rpcParams)
    {
        return ::SignMessage(rpcParams);
    }
    char* StatusGoWrapper::CallRPC(char* inputJSON)
    {
        return ::CallRPC(inputJSON);
    }
    char* StatusGoWrapper::StopLocalNotifications()
    {
        return ::StopLocalNotifications();
    }
    char* StatusGoWrapper::ValidateMnemonic(char* mnemonic)
    {
        return ::ValidateMnemonic(mnemonic);
    }
    char* StatusGoWrapper::SerializeLegacyKey(char* key)
    {
        return ::SerializeLegacyKey(key);
    }
    char* StatusGoWrapper::ChangeDatabasePassword(char* KeyUID, char* password, char* newPassword)
    {
        return ::ChangeDatabasePassword(KeyUID, password, newPassword);
    }
    char* StatusGoWrapper::EncodeFunctionCall(char* method, char* paramsJSON)
    {
        ::EncodeFunctionCall(method, paramsJSON);
    }
    char* StatusGoWrapper::ResetChainData()
    {
        return::ResetChainData();
    }

    char* StatusGoWrapper::Recover(char* rpcParams)
    {
        return ::Recover(rpcParams);
    }
    char* StatusGoWrapper::StartCPUProfile(char* dataDir)
    {
        return ::StartCPUProfile(dataDir);
    }
    char* StatusGoWrapper::StopCPUProfiling()
    {
        return ::StopCPUProfiling();
    }
    char* StatusGoWrapper::ExportNodeLogs()
    {
        return ::ExportNodeLogs();
    }
    char* StatusGoWrapper::InputConnectionStringForBootstrappingAnotherDevice(char* cs, char* configJSON)
    {
        return ::InputConnectionStringForBootstrappingAnotherDevice(cs, configJSON);
    }
    char* StatusGoWrapper::IsAddress(char* address)
    {
        return ::IsAddress(address);
    }
    char* StatusGoWrapper::MultiformatDeserializePublicKey(char* key, char* outBase)
    {
        return ::MultiformatDeserializePublicKey(key, outBase);
    }
    char* StatusGoWrapper::InputConnectionStringForBootstrapping(char* cs, char* configJSON)
    {
        return ::InputConnectionStringForBootstrapping(cs, configJSON);
    }
    char* StatusGoWrapper::SignGroupMembership(char* content)
    {
        return ::SignGroupMembership(content);
    }
    char* StatusGoWrapper::VerifyDatabasePassword(char* keyUID, char* password)
    {
        return ::VerifyDatabasePassword(keyUID, password);
    }
    char* StatusGoWrapper::DeleteImportedKey(char* address, char* password, char* keyStoreDir)
    {
        return ::DeleteImportedKey(address, password, keyStoreDir);
    }
    void StatusGoWrapper::ConnectionChange(char* typ, int expensive)
    {
        ::ConnectionChange(typ, expensive);
    }
    char* StatusGoWrapper::EmojiHash(char* pk)
    {
        return ::EmojiHash(pk);
    }
    char* StatusGoWrapper::SendTransactionWithChainID(int chainID, char* txArgsJSON, char* password)
    {
        return ::SendTransactionWithChainID(chainID, txArgsJSON, password);
    }
    char* StatusGoWrapper::SendTransaction(char* txArgsJSON, char* password)
    {
        return ::SendTransaction(txArgsJSON, password);
    }
    char* StatusGoWrapper::MultiformatSerializePublicKey(char* key, char* outBase)
    {
        return ::MultiformatSerializePublicKey(key, outBase);
    }
    char* StatusGoWrapper::SwitchFleet(char* fleet, char* configJSON)
    {
        return ::SwitchFleet(fleet, configJSON);
    }
    char* StatusGoWrapper::Utf8ToHex(char* str)
    {
        return ::Utf8ToHex(str);
    }
    char* StatusGoWrapper::CheckAddressChecksum(char* address)
    {
        return ::CheckAddressChecksum(address);
    }
    char* StatusGoWrapper::GetNodeConfig()
    {
        return ::GetNodeConfig();
    }
    char* StatusGoWrapper::CreateAccountAndLogin(char* requestJSON)
    {
        return ::CreateAccountAndLogin(requestJSON);
    }
    char* StatusGoWrapper::SendTransactionWithSignature(char* txArgsJSON, char* sigString)
    {
        return ::SendTransactionWithSignature(txArgsJSON, sigString);
    }
    char* StatusGoWrapper::DecompressPublicKey(char* key)
    {
        return ::DecompressPublicKey(key);
    }
    char* StatusGoWrapper::ExtractGroupMembershipSignatures(char* signaturePairsStr)
    {
        return ::ExtractGroupMembershipSignatures(signaturePairsStr);
    }
    char* StatusGoWrapper::HashTypedData(char* data)
    {
        return ::HashTypedData(data);
    }
    char* StatusGoWrapper::HashTypedDataV4(char* data)
    {
        return ::HashTypedDataV4(data);
    }
    char* StatusGoWrapper::ValidateConnectionString(char* cs)
    {
        return ::ValidateConnectionString(cs);
    }
    char* StatusGoWrapper::StartLocalNotifications()
    {
        return ::StartLocalNotifications();
    }
    char* StatusGoWrapper::GenerateImages(char* filepath, int aX, int aY, int bX, int bY)
    {
        return ::GenerateImages(filepath, aX, aY, bX, bY);
    }
    char* StatusGoWrapper::HexToUtf8(char* hexString)
    {
        return ::HexToUtf8(hexString);
    }
    char* StatusGoWrapper::DecodeParameters(char* decodeParamJSON)
    {
        return ::DecodeParameters(decodeParamJSON);
    }
    char* StatusGoWrapper::SignTypedData(char* data, char* address, char* password)
    {
        return ::SignTypedData(data, address, password);
    }
    char* StatusGoWrapper::AddPeer(char* enode)
    {
        return ::AddPeer(enode);
    }
    char* StatusGoWrapper::SignHash(char* hexEncodedHash)
    {
        return ::SignHash(hexEncodedHash);
    }
    char* StatusGoWrapper::ColorID(char* pk)
    {
        return ::ColorID(pk);
    }
    char* StatusGoWrapper::ConvertToKeycardAccount(char* accountData, char* settingsJSON, char* keycardUID, char* password, char* newPassword)
    {
        return ::ConvertToKeycardAccount(accountData, settingsJSON, keycardUID, password, newPassword);
    }
    char* StatusGoWrapper::ImageServerTLSCert()
    {
        return ::ImageServerTLSCert();
    }
    char* StatusGoWrapper::GetConnectionStringForBootstrappingAnotherDevice(char* configJSON)
    {
        return ::GetConnectionStringForBootstrappingAnotherDevice(configJSON);
    }
    char* StatusGoWrapper::MigrateKeyStoreDir(char* accountData, char* password, char* oldDir, char* newDir)
    {
        return ::MigrateKeyStoreDir(accountData, password, oldDir, newDir);
    }
    char* StatusGoWrapper::HexToNumber(char* hex)
    {
        return ::HexToNumber(hex);
    }
    char* StatusGoWrapper::WriteHeapProfile(char* dataDir)
    {
        return ::WriteHeapProfile(dataDir);
    }
    char* StatusGoWrapper::CompressPublicKey(char* key)
    {
        return ::CompressPublicKey(key);
    }
    char* StatusGoWrapper::ExportUnencryptedDatabase(char* accountData, char* password, char* databasePath)
    {
        return ::ExportUnencryptedDatabase(accountData, password, databasePath);
    }
    char* StatusGoWrapper::GetPasswordStrengthScore(char* paramsJSON)
    {
        return ::GetPasswordStrengthScore(paramsJSON);
    }
    char* StatusGoWrapper::GetConnectionStringForBeingBootstrapped(char* configJSON)
    {
        return ::GetConnectionStringForBeingBootstrapped(configJSON);
    }
    char* StatusGoWrapper::DeserializeAndCompressKey(char* DesktopKey)
    {
        return ::DeserializeAndCompressKey(DesktopKey);
    }
    char* StatusGoWrapper::ValidateNodeConfig(char* configJSON)
    {
        return ::ValidateNodeConfig(configJSON);
    }
    char* StatusGoWrapper::SignTypedDataV4(char* data, char* address, char* password)
    {
        return ::SignTypedDataV4(data, address, password);
    }
    char* StatusGoWrapper::ColorHash(char* pk)
    {
        return ::ColorHash(pk);
    }
    char* StatusGoWrapper::ImportUnencryptedDatabase(char* accountData, char* password, char* databasePath)
    {
        return ::ImportUnencryptedDatabase(accountData, password, databasePath);
    }
    char* StatusGoWrapper::Sha3(char* str)
    {
        return ::Sha3(str);
    }
    char* StatusGoWrapper::ToChecksumAddress(char* address)
    {
        return ::ToChecksumAddress(address);
    }
    char* StatusGoWrapper::RestoreAccountAndLogin(char* requestJSON)
    {
        return ::RestoreAccountAndLogin(requestJSON);
    }
    char* StatusGoWrapper::IsAlias(char* value)
    {
        return ::IsAlias(value);
    }
    char* StatusGoWrapper::Identicon(char* pk)
    {
        return ::Identicon(pk);
    }
    char* StatusGoWrapper::GetPasswordStrength(char* paramsJSON)
    {
        return ::GetPasswordStrength(paramsJSON);
    }
    char* StatusGoWrapper::StartSearchForLocalPairingPeers()
    {
        return ::StartSearchForLocalPairingPeers();
    }
    char* StatusGoWrapper::EncodeTransfer(char* to, char* value)
    {
        return ::EncodeTransfer(to, value);
    }
    char* StatusGoWrapper::NumberToHex(char* numString)
    {
        return ::NumberToHex(numString);
    }
    char* StatusGoWrapper::HashTransaction(char* txArgsJSON)
    {
        return ::HashTransaction(txArgsJSON);
    }
    char* StatusGoWrapper::HashMessage(char* message)
    {
        return ::HashMessage(message);;
    }
    char* StatusGoWrapper::MultiAccountImportPrivateKey(char* paramsJSON)
    {
        return ::MultiAccountImportPrivateKey(paramsJSON);
    }
    char* StatusGoWrapper::CreateAccountFromPrivateKey(char* paramsJSON)
    {
        return ::CreateAccountFromPrivateKey(paramsJSON);
    }

    char* StatusGoWrapper::MultiAccountDeriveAddresses(char* paramsJSON)
    {
        return ::MultiAccountDeriveAddresses(paramsJSON);
    }
    char* StatusGoWrapper::MultiAccountLoadAccount(char* paramsJSON)
    {
        return ::MultiAccountLoadAccount(paramsJSON);
    }
    char* StatusGoWrapper::MultiAccountReset()
    {
        return ::MultiAccountReset();
    }
    char* StatusGoWrapper::MultiAccountImportMnemonic(char* paramsJSON)
    {
        return ::MultiAccountImportMnemonic(paramsJSON);
    }
    char* StatusGoWrapper::CreateAccountFromMnemonicAndDeriveAccountsForPaths(char* paramsJSON)
    {
        return ::CreateAccountFromMnemonicAndDeriveAccountsForPaths(paramsJSON);
    }
    void StatusGoWrapper::Free(void* param)
    {
        ::Free(param);
    }
    */
}
