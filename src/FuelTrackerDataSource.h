/*
 * FuelTrackerDataSource.h
 *
 *  Created on: Jun 28, 2015
 *      Author: rich
 */

#ifndef FUELTRACKERDATASOURCE_H_
#define FUELTRACKERDATASOURCE_H_

#include <QObject>
#include <bb/data/DataSource>
#include <bb/data/SqlConnection>

using namespace bb::data;

namespace bb
{
    namespace data
    {
        class SqlConnection;
    }
}

class FuelTrackerDataSource : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString query READ query WRITE setQuery NOTIFY queryChanged)

    public:
        FuelTrackerDataSource(QObject *parent = 0);
        virtual ~FuelTrackerDataSource();

        void setSource(const QString source);
        QString source();
        void setQuery(const QString query);
        QString query();

        Q_INVOKABLE void load();
        Q_INVOKABLE void execute(const QString& query, const QVariantMap &valuesByName, int id = 1);

    signals:
        void sourceChanged(QString source);
        void queryChanged(QString query);
        void dataLoaded(const QVariant &data);
        void reply(const bb::data::DataAccessReply &replyData);

    private slots:
        void onLoadAsyncResultData(const bb::data::DataAccessReply &reply);

    private:
        void copyFileToDataFolder(const QString fileName);
        bool checkConnection();

        QString mSource;
        QString mQuery;
        QString mSourceInDataFolder;
        SqlConnection *mSqlConnector;
        DataSource *mDataSource;
        static int const LOAD_EXECUTION;
};

#endif /* FUELTRACKERDATASOURCE_H_ */
