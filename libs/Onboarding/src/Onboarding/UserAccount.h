#pragma once

#include <QtQmlIntegration>
#include "Accounts/MultiAccount.h"

namespace Status::Onboarding
{

struct MultiAccount;

/*!
 * \brief Represents a user account in Onboarding Presentation Layer
 *
 * @see OnboardingController
 * @see UserAccountsModel
 */
class UserAccount : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_UNCREATABLE("Created by Controller")

    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
public:
    explicit UserAccount(std::unique_ptr<MultiAccount> data);
    virtual ~UserAccount(){};
    const QString& name() const;

    const MultiAccount& accountData() const;
    void updateAccountData(const MultiAccount& newData);

signals:
    void nameChanged();

private:
    std::unique_ptr<MultiAccount> m_data;
};

} // namespace Status::Onboarding
