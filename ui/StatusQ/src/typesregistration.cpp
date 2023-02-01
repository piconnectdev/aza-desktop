#include "StatusQ/typesregistration.h"

#include "StatusQ/QClipboardProxy.h"
#include "StatusQ/statussyntaxhighlighter.h"
#include "StatusQ/statuswindow.h"
#include "StatusQ/rxvalidator.h"

#include <QQmlEngine>

void registerStatusQTypes()
{
	qmlRegisterType<StatusWindow>("StatusQ", 0 , 1, "StatusWindow");
    qmlRegisterSingletonType<QClipboardProxy>("StatusQ", 0 , 1, "QClipboardProxy",
                                              &QClipboardProxy::qmlInstance);
    qmlRegisterType<StatusSyntaxHighlighter>("StatusQ", 0 , 1, "StatusSyntaxHighlighter");
    qmlRegisterType<RXValidator>("StatusQ", 0 , 1, "RXValidator");
}