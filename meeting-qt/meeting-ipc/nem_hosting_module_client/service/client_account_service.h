﻿// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#ifndef NEM_HOSTING_MODULE_CLIENT_SERVICE_ACCOUNT_SERVICE_H_
#define NEM_HOSTING_MODULE_CLIENT_SERVICE_ACCOUNT_SERVICE_H_
#include "client_nemeeting_sdk_interface_include.h"
#include "nem_hosting_module_client/config/build_config.h"
#include "nem_hosting_module_core/service/service.h"

NNEM_SDK_HOSTING_MODULE_CLIENT_BEGIN_DECLS

USING_NS_NNEM_SDK_INTERFACE

USING_NS_NNEM_SDK_HOSTING_MODULE_CORE

class NEM_SDK_INTERFACE_EXPORT NEAccountServiceIMP : public NEAccountServiceIPCClient, public IService<NS_NIPCLIB::IPCClient> {
    friend NEMeetingSDKIPCClient* NEMeetingSDKIPCClient::getInstance();

public:
    NEAccountServiceIMP();
    ~NEAccountServiceIMP();

public:
    virtual void getPersonalMeetingId(const NEGetPersonalMeetingIdCallback& cb) override;

    virtual void OnLoad() override;
    virtual void OnRelease() override;

private:
    void OnPack(int cid, const std::string& data, const IPCAsyncResponseCallback& cb) override{};
    virtual void OnPack(int cid, const std::string& data, uint64_t sn) override;
};

NNEM_SDK_HOSTING_MODULE_CLIENT_END_DECLS

#endif  // NEM_HOSTING_MODULE_CLIENT_SERVICE_ACCOUNT_SERVICE_H_