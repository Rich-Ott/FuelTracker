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

#include <bb/cascades/GroupDataModel>
#include <bb/cascades/ListView>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/Page>

#include "FuelTrackerApp.h"
//#include "FuelTrackerDbHelper.h"

using namespace bb::cascades;

FuelTrackerApp::FuelTrackerApp()
{
}

FuelTrackerApp::~FuelTrackerApp()
{
    //delete fuelTrackerDbHelper;
}

void FuelTrackerApp::onStart()
{
    //fuelTrackerDbHelper = new FuelTrackerDbHelper();

    if(!loadQMLScene())
    {
        qWarning("Failed to load QML scene");
    }
}

bool FuelTrackerApp::loadQMLScene()
{
    QmlDocument *qmlDocument = QmlDocument::create("asset:///main.qml");
    if(!qmlDocument->hasErrors())
    {
        qmlDocument->setContextProperty("fuelTrackerApp", this);
    }

    Page *mainPage = qmlDocument->createRootObject<Page>();

    if(mainPage)
    {
        //QVariantList sqlData = fuelTrackerDbHelper->loadDatabase("v1.0.0.db")
        Application::instance()->setScene(mainPage);
        return true;
    }

    return false;
}
