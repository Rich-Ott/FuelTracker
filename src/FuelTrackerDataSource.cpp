/*
 * FuelTrackerDataSource.cpp
 *
 *  Created on: Jun 28, 2015
 *      Author: rich
 */

#include "FuelTrackerDataSource.h"

int const FuelTrackerDataSource::LOAD_EXECUTION = 0;

FuelTrackerDataSource::FuelTrackerDataSource(QObject *parent) : QObject(parent),
        mSqlConnector(0), mDataSource(0)
{
}

FuelTrackerDataSource::~FuelTrackerDataSource()
{
    delete mSqlConnector;
}

void FuelTrackerDataSource::copyFileToDataFolder(const QString fileName)
{
    QString dataFolder = QDir::homePath();
    QString newFileName = dataFolder + "/" + fileName;
    QFile newFile(newFileName);

    if(!newFile.exists())
    {
        QString appFolder(QDir::homePath());
        appFolder.chop(4);
        QString originalFileName = appFolder + "app/native/assets/" + fileName;
        QFile originalFile(originalFileName);

        if(originalFile.exists())
        {
            QFileInfo fileInfo(newFileName);
            QDir().mkpath(fileInfo.dir().path());

            if(!originalFile.copy(newFileName))
            {
                qDebug() << "Failed to copy file to path: " << newFileName;
            }
        }
        else
        {
            qDebug() << "Failed to copy file, database file does not exist.";
        }
    }
    mSourceInDataFolder = newFileName;
}

void FuelTrackerDataSource::setSource(const QString source)
{
    if(mSource.compare(source) != 0)
    {
        copyFileToDataFolder(source);
        mSource = source;
        emit sourceChanged(mSource);
    }
}

QString FuelTrackerDataSource::source()
{
    return mSource;
}

void FuelTrackerDataSource::setQuery(const QString query)
{
    if(mQuery.compare(query)!= 0)
    {
        mQuery = query;
        emit queryChanged(mQuery);
    }
}

QString FuelTrackerDataSource::query()
{
    return mQuery;
}

bool FuelTrackerDataSource::checkConnection()
{
    bool connectResult;
    Q_UNUSED(connectResult);

    if(mSqlConnector)
    {
        return true;
    }
    else
    {
        QFile newFile(mSourceInDataFolder);

        if(newFile.exists())
        {
            if(mSqlConnector)
            {
                disconnect(mSqlConnector, SIGNAL(reply(const bb::data::DataAccessReply&)), this,
                                          SLOT(onLoadAsyncResultData(const bb::data::DataAccessReply&)));
                delete mSqlConnector;
            }
            mSqlConnector = new SqlConnection(mSourceInDataFolder, "connect");

            connectResult = connect(mSqlConnector, SIGNAL(reply(const bb::data::DataAccessReply&)), this,
                                                   SLOT(onLoadAsyncResultData(const bb::data::DataAccessReply&)));
            Q_ASSERT(connectResult);
            return true;
        }
        else
        {
            qDebug() << "FuelTrackerDataSource::checkConnection failed to load database, file does not exist.";
        }
    }
    return false;
}

void FuelTrackerDataSource::execute(const QString &query, const QVariantMap &valuesByName, int id)
{
    if(checkConnection())
    {
        mSqlConnector->execute(query, valuesByName, id);
    }
}

void FuelTrackerDataSource::load()
{
    if(mQuery.isEmpty() == false)
    {
        if(checkConnection())
        {
            mSqlConnector->execute(mQuery, LOAD_EXECUTION);
        }
    }
}

void FuelTrackerDataSource::onLoadAsyncResultData(const bb::data::DataAccessReply &replyData)
{
    if(replyData.hasError())
    {
        qWarning() << "onLoadAsyncResultData: " << replyData.id() << ", SQL error: " << replyData;
    }
    else
    {
        if(replyData.id() == LOAD_EXECUTION)
        {
            QVariantList resultList = replyData.result().value<QVariantList>();
            emit dataLoaded(resultList);
        }
        else
        {
            emit reply(replyData);
        }
    }
}
