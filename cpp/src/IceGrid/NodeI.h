// **********************************************************************
//
// Copyright (c) 2003-2005 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_GRID_NODE_I_H
#define ICE_GRID_NODE_I_H

#include <IceGrid/Internal.h>

namespace IceGrid
{

class TraceLevels;
typedef IceUtil::Handle<TraceLevels> TraceLevelsPtr;

class Activator;
typedef IceUtil::Handle<Activator> ActivatorPtr;

class WaitQueue;
typedef IceUtil::Handle<WaitQueue> WaitQueuePtr;

class NodeI : public Node, public IceUtil::Mutex
{
public:

    NodeI(const Ice::ObjectAdapterPtr&, const ActivatorPtr&, const WaitQueuePtr&, const TraceLevelsPtr&, 
	  const NodePrx&, const std::string&);

    virtual ServerPrx loadServer(const ServerDescriptorPtr&, StringAdapterPrxDict&, const Ice::Current&);
    virtual void destroyServer(const std::string&, const Ice::Current&);
    
    virtual std::string getName(const Ice::Current&) const;
    virtual std::string getHostname(const Ice::Current&) const;
    virtual void shutdown(const Ice::Current&) const;

    WaitQueuePtr getWaitQueue() const;
    Ice::CommunicatorPtr getCommunicator() const;
    ActivatorPtr getActivator() const;
    TraceLevelsPtr getTraceLevels() const;
    NodeObserverPrx getObserver() const;

    NodeSessionPrx getSession() const;
    void setSession(const NodeSessionPrx&);
    void keepAlive();
    void stop();

private:

    void checkConsistency();
    void checkConsistencyNoSync(const Ice::StringSeq&);
    bool canRemoveServerDirectory(const std::string&);
    void initObserver(const Ice::StringSeq&);

    const Ice::ObjectAdapterPtr _adapter;
    const ActivatorPtr _activator;
    const WaitQueuePtr _waitQueue;
    const TraceLevelsPtr _traceLevels;
    const std::string _name;
    const std::string _hostname;
    const NodePrx _proxy;
    std::string _serversDir;
    std::string _tmpDir;
    unsigned long _serial;
    NodeObserverPrx _observer;
    IceUtil::Mutex _sessionMutex;
    NodeSessionPrx _session;
    std::set<std::string> _servers;
    std::set<std::string> _adapters;
};
typedef IceUtil::Handle<NodeI> NodeIPtr;

}

#endif
