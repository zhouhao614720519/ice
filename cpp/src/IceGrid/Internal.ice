// **********************************************************************
//
// Copyright (c) 2003-2005 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#ifndef ICE_GRID_INTERNAL_ICE
#define ICE_GRID_INTERNAL_ICE

#include <Ice/Identity.ice>
#include <Ice/BuiltinSequences.ice>
#include <Ice/ProcessF.ice>
#include <Glacier2/Session.ice>
#include <IceGrid/Admin.ice>
#include <IceGrid/Observer.ice>

module IceGrid
{

/**
 *
 * This exception is raised if an adapter is active.
 *
 **/
exception AdapterActiveException
{
};

exception AdapterNotActiveException
{
    /** True if the adapter can be activated on demand. */
    bool activatable;
    
    /** How long to wait for the adapter to become active. */
    int timeout;
};

interface Adapter
{
    /**
     *
     * Activate this adapter. If this adapter can be activated, this 
     * will activate the adapter and return the direct proxy of the 
     * adapter once it's active. If this adapter can be activated on
     * demand, this will return 0 if the adapter is inactive or the
     * adapter direct proxy it's active.
     *
     **/
    ["ami", "amd"] Object* activate();    

    /**
     *
     * Get the adapter direct proxy. The adapter direct proxy is a
     * proxy created with the object adapter. The proxy contains the
     * last known adapter endpoints.
     *
     * @return A direct proxy containing the last known adapter
     * endpoints if the adapter is already active.
     *
     **/
     ["ami"] nonmutating Object* getDirectProxy()
	throws AdapterNotActiveException;

    /**
     *
     * Set the direct proxy for this adapter.
     *
     * @param The direct proxy. The direct proxy should be created
     * with the object adapter and should contain the object adapter
     * endpoints.
     *
     * @throws AdapterActiveException The adapter is already
     * active. It's not possible to override the direct proxy of an
     * active adapter.
     *
     **/
    ["ami"] void setDirectProxy(Object* proxy)
	throws AdapterActiveException;

    /**
     *
     * Destroy the adapter.
     *
     **/
    void destroy();
};
dictionary<string, Adapter*> StringAdapterPrxDict;

/**
 *
 * This exception is raised if an adapter with the same name already
 * exists.
 *
 **/
exception AdapterExistsException
{
    string id;
};

interface Server
{
    /**
     *
     * Load the server.
     *
     **/
    void load(ServerDescriptor desc, out StringAdapterPrxDict adapters)
	throws DeploymentException;

    /**
     *
     * Start the server.
     *
     * @param mode The activation mode requested, start returns false
     * if the activation mode requested is not compatible with the
     * server activation mode. For example if mode is Automatic and
     * the server activation mode is Manual the start will return
     * false.
     *
     * @return True if the server was successfully started, false
     * otherwise.
     *
     **/
    bool start(ServerActivation mode);

    /**
     *
     * Stop the server. This methods returns only when the server is
     * deactivated. If the server doesn't stop after a configurable
     * amount of time, it will be killed.
     *
     **/
    void stop();

    /**
     *
     * Send signal to the server
     *
     **/
    void sendSignal(string signal) 
	throws BadSignalException;
    
    /**
     *
     * Write message on servers' stdout or stderr.
     *
     **/
    void writeMessage(string message, int fd);

    /**
     *
     * Destroy the server. This method destroys the server and
     * eventually deactivates if it's still active.
     *
     **/
    void destroy();
    
    /**
     *
     * This method is called by the activator when it detects that the
     * server has terminated.
     *
     **/
    void terminated();

    /**
     *
     * Return the server state.
     *
     * @return The server state.
     *
     * @see ServerState
     *
     **/
    ServerState getState();

    /**
     *
     * Get the server pid. Note that the value returned by this method
     * is system dependant. On Unix operating systems, it's the pid
     * value returned by the fork() system call and converted to an
     * integer.
     *
     **/
    int getPid();

    /**
     *
     * Get the descriptor used to deploy this server.
     *
     **/
    ServerDescriptor getDescriptor();

    /**
     *
     * Set the server activation mode.
     *
     **/
    void setActivationMode(ServerActivation mode);

    /**
     *
     * Get the server activation mode.
     *
     **/
    ServerActivation getActivationMode();

    /**
     *
     * Set the process proxy.
     *
     **/
    ["ami"] void setProcess(Ice::Process* proc);

    /**
     *
     * Get the server adapters.
     * 
     **/
    StringAdapterPrxDict getAdapters();
};

interface Node
{
    /**
     *
     * Load the given server. If the server resources weren't already
     * created (database environment directories, property files, etc),
     * they will be created.
     *
     **/
    idempotent Server* loadServer(ServerDescriptor desc, out StringAdapterPrxDict adapters)
	throws DeploymentException;

    /**
     *
     * Destroy the given server.
     *
     **/
    idempotent void destroyServer(string name);

    /**
     *
     * Get the node name.
     *
     **/
    nonmutating string getName();    

    /**
     *
     * Get the node hostname.
     *
     **/
    nonmutating string getHostname();    

    /**
     *
     * Shutdown the node.
     *
     **/
    nonmutating void shutdown();
};

/**
 *
 * This exception is raised if a node is already registered and
 * active.
 *
 **/
exception NodeActiveException
{
};

interface NodeSession extends Glacier2::Session
{
    /**
     *
     * The node call this method to keep the session alive.
     *
     **/
    void keepAlive();

    /**
     *
     * Get the name of the servers deployed on the node.
     *
     **/
    Ice::StringSeq getServers();
};

interface Registry
{
    /**
     *
     * Register a node with the registry. If a node with the same name
     * is already registered, [registerNode] will overide the previous
     * node only if it's not active.
     *
     * @param name The name of the node to register.
     *
     * @param nd The proxy of the node.
     *
     * @return The name of the servers currently deployed on the node.
     * 
     * @throws NodeActiveException Raised if the node is already
     * registered and currently active.
     *
     **/
    NodeSession* registerNode(string name, Node* nd)
	throws NodeActiveException;

    /**
     *
     * Get the node observer object. This is used by nodes to publish
     * updates about the state of the nodes (server up/down, etc).
     *
     **/
    NodeObserver* getNodeObserver();

    /**
     *
     * Shutdown the registry.
     *
     **/
    void shutdown();
};

};

#endif
