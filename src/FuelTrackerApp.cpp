/*
 * Copyright (c) 2015 Richard Ott
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "FuelTrackerApp.h"
#include "FuelTrackerDataSource.h"

#include <bb/cascades/ListView>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/Page>

using namespace bb::cascades;

FuelTrackerApp::FuelTrackerApp(QObject *parent) : QObject(parent),
        mTranslator(0), mLocaleHandler(0)
{
}

FuelTrackerApp::~FuelTrackerApp()
{
}

void FuelTrackerApp::onStart()
{
    DataSource::registerQmlTypes();

    if(!loadQMLScene())
    {
        qWarning("Failed to load QML scene");
    }
}

bool FuelTrackerApp::loadQMLScene()
{
    mTranslator = new QTranslator(this);
    mLocaleHandler = new LocaleHandler(this);
    onSystemLanguageChanged();
    bool connectResult = connect(mLocaleHandler, SIGNAL(systemLanguageChanged()), SLOT(onSystemLanguageChanged()));
    Q_ASSERT(connectResult);
    Q_UNUSED(connectResult);

    qmlRegisterType<FuelTrackerDataSource>("com.FuelTracker.data", 1, 0, "FuelTrackerDataSource");

    QmlDocument *qmlDocument = QmlDocument::create("asset:///main.qml").parent(this);
    if(!qmlDocument->hasErrors())
    {
        qmlDocument->setContextProperty("fuelTrackerApp", this);

        Page *mainPage = qmlDocument->createRootObject<Page>();
        if(mainPage)
        {
            Application::instance()->setScene(mainPage);
            return true;
        }
    }
    else
    {
        QList<QDeclarativeError> x = qmlDocument->errors();
        qDebug("TEST");
        qDebug() << x[0].toString();
    }
    return false;
}

void FuelTrackerApp::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(mTranslator);

    QString localeString = QLocale().name();
    QString fileName = QString("fuelTracker_%1").arg(localeString);
    if(mTranslator->load(fileName, "app/native/qm"))
    {
        QCoreApplication::instance()->installTranslator(mTranslator);
    }
}
