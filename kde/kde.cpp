/***
Pix  Copyright (C) 2018  Camilo Higuita
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.

 This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
***/

#include "kde.h"
#include <KService>
#include <KMimeTypeTrader>
#include <KToolInvocation>
#include <KLocalizedString>
#include <QDebug>
#include <KRun>
#include <QFileInfo>
#include <KService>
#include <KServiceGroup>
#include <QDebug>

#include "../app/inx.h"

KDE::KDE(QObject *parent) : QObject(parent) {}

QVariantList KDE::getApps()
{
    QVariantList res;
    KServiceGroup::Ptr group = KServiceGroup::root();

    bool sortByGenericName = false;

    KServiceGroup::List list = group->entries(true /* sorted */, true /* excludeNoDisplay */,
                                              true /* allowSeparators */, sortByGenericName /* sortByGenericName */);

    for (KServiceGroup::List::ConstIterator it = list.constBegin(); it != list.constEnd(); it++)
    {
        const KSycocaEntry::Ptr p = (*it);

        if (p->isType(KST_KServiceGroup))
        {
            KServiceGroup::Ptr s(static_cast<KServiceGroup*>(p.data()));

            if (!s->noDisplay() && s->childCount() > 0)
            {
                qDebug()<< "Getting app"<<s->icon();

                res << QVariantMap
                {
                {INX::MODEL_NAME[INX::MODEL_KEY::ICON], s->icon()},
                {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], s->name()},
                {INX::MODEL_NAME[INX::MODEL_KEY::PATH], INX::CUSTOMPATH_PATH[INX::CUSTOMPATH::APPS]+"/"+s->entryPath()}
            };
        }
    }
}
return res;
}

QVariantList KDE::getApps(const QString &groupStr)
{
    if(groupStr.isEmpty()) return getApps();

    QVariantList res;
//    const KServiceGroup::Ptr group(static_cast<KServiceGroup*>(groupStr));
        auto group = new KServiceGroup(groupStr);
    KServiceGroup::List list = group->entries(true /* sorted */,
                                              true /* excludeNoDisplay */,
                                              false /* allowSeparators */,
                                              true /* sortByGenericName */);

    for (KServiceGroup::List::ConstIterator it = list.constBegin(); it != list.constEnd(); it++)
    {
        const KSycocaEntry::Ptr p = (*it);

        if (p->isType(KST_KService))
        {
            const KService::Ptr s(static_cast<KService*>(p.data()));

            if (s->noDisplay())
                continue;

            res << QVariantMap {

            {INX::MODEL_NAME[INX::MODEL_KEY::ICON], s->icon()},
            {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], s->name()},
            {INX::MODEL_NAME[INX::MODEL_KEY::PATH], s->entryPath()}
        };


    } else if (p->isType(KST_KServiceSeparator))
    {
        qDebug()<< "separator wtf";

    } else if (p->isType(KST_KServiceGroup))
    {
        const KServiceGroup::Ptr s(static_cast<KServiceGroup*>(p.data()));

        if (s->childCount() == 0)
            continue;

        res << QVariantMap {

        {INX::MODEL_NAME[INX::MODEL_KEY::ICON], s->icon()},
        {INX::MODEL_NAME[INX::MODEL_KEY::LABEL], s->name()},
        {INX::MODEL_NAME[INX::MODEL_KEY::PATH], INX::CUSTOMPATH_PATH[INX::CUSTOMPATH::APPS]+"/"+s->entryPath()}
    };
}
}

return res;
}

void KDE::launchApp(const QString &app)
{
    KService service(app);
    KRun::runApplication(service,{}, nullptr);
}
