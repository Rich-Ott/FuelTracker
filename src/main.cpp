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
#include <Qt/qdeclarativedebug.h>

using namespace bb::cascades;


void myMessageOutput(QtMsgType type, const char* msg){
    Q_UNUSED(type);
    fprintf(stdout, "%s\n", msg);
    fflush(stdout);
}

Q_DECL_EXPORT int main(int argc, char **argv)
{
    qInstallMsgHandler(myMessageOutput);

    Application app(argc, argv);

    FuelTrackerApp fuelTrackerApp;
    fuelTrackerApp.onStart();

    // Enter the application main event loop.
    return Application::exec();
}
