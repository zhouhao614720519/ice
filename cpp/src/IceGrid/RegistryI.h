// **********************************************************************
//
// Copyright (c) 2003-2005 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_GRID_REGISTRYI_H
#define ICE_GRID_REGISTRYI_H

#include <IceGrid/Internal.h>
#include <IceStorm/IceStorm.h>

namespace IceStorm
{

class TopicManagerI;
typedef IceUtil::Handle<TopicManagerI> TopicManagerIPtr;

}

namespace IceGrid
{

class Database;
typedef IceUtil::Handle<Database> DatabasePtr;

class ReapThread;
typedef IceUtil::Handle<ReapThread> ReapThreadPtr;    

class RegistryI : public Registry
{
public:

    RegistryI(const Ice::CommunicatorPtr&);
    ~RegistryI();

    bool start(bool);
    void stop();

    virtual NodeSessionPrx registerNode(const std::string&, const NodePrx&, const Ice::Current&);
    virtual NodeObserverPrx getNodeObserver(const Ice::Current&);
    virtual void shutdown(const Ice::Current& current);

    virtual IceStorm::TopicManagerPrx getTopicManager();

private:

    Ice::CommunicatorPtr _communicator;
    DatabasePtr _database;
    ReapThreadPtr _reaper;
    int _nodeSessionTimeout;

    IceStorm::TopicManagerIPtr _topicManager;
    IceStorm::TopicManagerPrx _topicManagerProxy;
    RegistryObserverPrx _registryObserver;
    NodeObserverPrx _nodeObserver;
};
typedef IceUtil::Handle<RegistryI> RegistryIPtr;

}

#endif
