<!--
  Copyright (C) 2023 Nethesis S.r.l.
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-skeleton-text
            v-show="loading.getConfiguration"
            heading
            paragraph
            :line-count="15"
            width="80%"
          ></cv-skeleton-text>
          <cv-form
            v-show="!loading.getConfiguration"
            @submit.prevent="configureModule"
          >
            <cv-text-input
              :label="$t('settings.SOGo_fqdn')"
              placeholder="SOGo.example.org"
              v-model.trim="host"
              class="mg-bottom"
              :invalid-message="$t(error.host)"
              :disabled="stillLoading"
              ref="host"
            >
            </cv-text-input>
            <NsToggle
              value="letsEncrypt"
              :label="core.$t('apps_lets_encrypt.request_https_certificate')"
              v-model="isLetsEncryptEnabled"
              :disabled="stillLoading"
              class="mg-bottom"
            >
              <template #tooltip>
                <div class="mg-bottom-sm">
                  {{ core.$t("apps_lets_encrypt.lets_encrypt_tips") }}
                </div>
                <div class="mg-bottom-sm">
                  <cv-link @click="goToCertificates">
                    {{ core.$t("apps_lets_encrypt.go_to_tls_certificates") }}
                  </cv-link>
                </div>
              </template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
            <cv-row
              v-if="isLetsEncryptCurrentlyEnabled && !isLetsEncryptEnabled"
            >
              <cv-column>
                <NsInlineNotification
                  kind="warning"
                  :title="
                    core.$t('apps_lets_encrypt.lets_encrypt_disabled_warning')
                  "
                  :description="
                    core.$t(
                      'apps_lets_encrypt.lets_encrypt_disabled_warning_description',
                      {
                        node: this.status.node_ui_name
                          ? this.status.node_ui_name
                          : this.status.node,
                      }
                    )
                  "
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <cv-row v-if="mail_server_URL.length === 0">
              <cv-column>
                <NsInlineNotification
                  kind="warning"
                  :title="$t('settings.mail_module_misconfigured')"
                  :description="
                    $t('settings.no_available_mail_domain_check_users')
                  "
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsComboBox
              v-model.trim="mail_server"
              :autoFilter="true"
              :autoHighlight="true"
              :title="$t('settings.mail_server_fqdn')"
              :label="$t('settings.choose_mail_server')"
              :options="mail_server_URL"
              :userInputLabel="core.$t('settings.choose_mail_server')"
              :acceptUserInput="false"
              :showItemType="true"
              :invalid-message="$t(error.mail_server)"
              :disabled="stillLoading"
              tooltipAlignment="start"
              tooltipDirection="top"
              ref="mail_server"
            >
              <template slot="tooltip">
                {{ $t("settings.choose_the_mail_server_to_use") }}
              </template>
            </NsComboBox>
            <!-- advanced options -->
            <cv-accordion ref="accordion" class="maxwidth mg-bottom">
              <cv-accordion-item :open="toggleAccordion[0]">
                <template slot="title">{{ $t("settings.advanced") }}</template>
                <template slot="content">
                  <cv-text-area
                    :label="$t('settings.adminList')"
                    v-model.trim="admin_users"
                    :invalid-message="error.admin_users"
                    :helper-text="$t('settings.Write_administrator_list')"
                    :value="admin_users"
                    class="maxwidth textarea mg-left"
                    ref="admin_users"
                    :placeholder="$t('settings.Write_administrator_list')"
                    :disabled="stillLoading"
                  >
                  </cv-text-area>
                  <NsToggle
                    value="auxiliary_account"
                    :label="$t('settings.auxiliary_account')"
                    v-model="isAuxiliaryAccountEnabled"
                    :form-item="true"
                    :disabled="stillLoading"
                    class="mg-bottom"
                  >
                    <template slot="tooltip">
                      <span>{{ $t("settings.auxiliary_account_tips") }}</span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <NsToggle
                    value="dav"
                    :label="$t('settings.dav')"
                    v-model="isDavEnabled"
                    :form-item="true"
                    :disabled="stillLoading"
                    class="mg-bottom"
                  >
                    <template slot="tooltip">
                      <span>{{ $t("settings.dav_tips") }}</span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <NsToggle
                    value="activesync"
                    :label="$t('settings.activesync')"
                    v-model="isActivesyncEnabled"
                    :form-item="true"
                    :disabled="stillLoading"
                    class="mg-bottom"
                  >
                    <template slot="tooltip">
                      <span>{{ $t("settings.activesync_tips") }}</span>
                    </template>
                    <template slot="text-left">{{
                      $t("settings.disabled")
                    }}</template>
                    <template slot="text-right">{{
                      $t("settings.enabled")
                    }}</template>
                  </NsToggle>
                  <NsTextInput
                    :label="$t('settings.workers_count')"
                    :placeholder="$t('settings.workers_count_placeholder')"
                    v-model.trim="workers_count"
                    type="number"
                    min="3"
                    max="100"
                    class="mg-bottom"
                    :invalid-message="error.workers_count"
                    :disabled="stillLoading"
                    ref="workers_count"
                    tooltipAlignment="center"
                    tooltipDirection="right"
                  >
                    <template slot="tooltip">
                      <div>{{ $t("settings.workers_count_tips") }}</div>
                    </template>
                  </NsTextInput>
                </template>
              </cv-accordion-item>
            </cv-accordion>
            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.configure-module')"
                  :description="error.configureModule"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <cv-row v-if="error.getStatus">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.get-status')"
                  :description="error.getStatus"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <cv-row v-if="validationErrorDetails.length">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="
                    core.$t('apps_lets_encrypt.cannot_obtain_certificate')
                  "
                  :showCloseButton="false"
                >
                  <template #description>
                    <div class="flex flex-col gap-2">
                      <div
                        v-for="(detail, index) in validationErrorDetails"
                        :key="index"
                      >
                        {{ detail }}
                      </div>
                    </div>
                  </template>
                </NsInlineNotification>
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.configureModule"
              :disabled="stillLoading"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";

export default {
  name: "Settings",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settings",
      },
      status: {},
      validationErrorDetails: [],
      urlCheckInterval: null,
      host: "",
      isLetsEncryptEnabled: false,
      isLetsEncryptCurrentlyEnabled: false,
      isActivesyncEnabled: true,
      isDavEnabled: true,
      isAuxiliaryAccountEnabled: true,
      mail_server: "",
      mail_domain: "",
      admin_users: "",
      workers_count: "3",
      mail_server_URL: [],
      user_domains_list: [],
      loading: {
        getConfiguration: false,
        configureModule: false,
        getStatus: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        host: "",
        lets_encrypt: "",
        http2https: "",
        mail_server: "",
        admin_users: "",
        workers_count: "",
        getStatus: false,
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    stillLoading() {
      return (
        this.loading.getConfiguration ||
        this.loading.configureModule ||
        this.loading.getStatus
      );
    },
  },
  created() {
    this.getConfiguration();
    this.getStatus();
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  methods: {
    goToCertificates() {
      this.core.$router.push("/settings/tls-certificates");
    },
    async getStatus() {
      this.loading.getStatus = true;
      this.error.getStatus = "";
      const taskAction = "get-status";
      const eventId = this.getUuid();
      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getStatusAborted
      );
      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getStatusCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.getStatus = this.getErrorMessage(err);
        this.loading.getStatus = false;
        return;
      }
    },
    getStatusAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getStatus = this.$t("error.generic_error");
      this.loading.getStatus = false;
    },
    getStatusCompleted(taskContext, taskResult) {
      this.status = taskResult.output;
      this.loading.getStatus = false;
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
        return;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      const config = taskResult.output;
      this.host = config.host;
      this.isLetsEncryptEnabled = config.lets_encrypt;
      this.isLetsEncryptCurrentlyEnabled = config.lets_encrypt;
      this.isActivesyncEnabled = config.activesync;
      this.isDavEnabled = config.dav;
      this.admin_users = config.admin_users.split(",").join("\n");
      this.workers_count = config.workers_count.toString();
      this.isAuxiliaryAccountEnabled = config.auxiliary_account;

      // force to reload mail_server value after dom update
      this.$nextTick(() => {
        const mail_server_tmp = config.mail_server;
        const mail_domain_tmp = config.mail_domain;
        if (mail_server_tmp && mail_domain_tmp) {
          this.mail_server = mail_server_tmp + "," + mail_domain_tmp;
        } else {
          this.mail_server = "";
        }
        // if mail_server_URL is empty, set default value
        if (this.mail_server_URL.length === 0) {
          // we want to avoid to save the form, there is no users set in the mail domain
          this.mail_server = "";
        }
      });

      this.mail_server_URL = config.mail_server_URL;
      this.user_domains_list = config.user_domains_list;
      this.loading.getConfiguration = false;
      this.focusElement("host");
    },
    isValidUser(user) {
      // test if user is valid login
      const re = /^[a-zA-Z0-9._-]+$/;
      return re.test(user);
    },
    validateConfigureModule() {
      this.clearErrors(this);

      let isValidationOk = true;
      if (!this.host) {
        this.error.host = "common.required";

        if (isValidationOk) {
          this.focusElement("host");
        }
        isValidationOk = false;
      }
      if (!this.mail_server) {
        this.error.mail_server = "common.required";

        if (isValidationOk) {
          this.focusElement("mail_server");
        }
        isValidationOk = false;
      }
      if (this.admin_users) {
        // test if the admin_users is valid
        const admin_users = this.admin_users.split("\n");
        for (const user of admin_users) {
          if (!this.isValidUser(user)) {
            this.toggleAccordion[0] = true;
            // set i18n error message and return user in object
            this.error.admin_users = this.$t("settings.invalid_user", {
              user: user,
            });
            isValidationOk = false;
            if (isValidationOk) {
              this.focusElement("admin_users");
            }
            break;
          }
        }
      }
      return isValidationOk;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;
      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        if (validationError.details) {
          // show inline error notification with details
          this.validationErrorDetails = validationError.details
            .split("\n")
            .filter((detail) => detail.trim() !== "");
        } else {
          // set i18n error message
          this.error[param] = this.$t("settings." + validationError.error);
          if (!focusAlreadySet) {
            this.focusElement(param);
            focusAlreadySet = true;
          }
        }
      }
    },
    async configureModule() {
      this.error.test_imap = false;
      this.error.test_smtp = false;
      const isValidationOk = this.validateConfigureModule();
      if (!isValidationOk) {
        return;
      }

      this.loading.configureModule = true;
      const taskAction = "configure-module";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );
      const tmparray = this.mail_server.split(",");
      const mail_server_tmp = tmparray[0];
      const mail_domain_tmp = tmparray[1];
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            host: this.host,
            lets_encrypt: this.isLetsEncryptEnabled,
            activesync: this.isActivesyncEnabled,
            dav: this.isDavEnabled,
            mail_server: mail_server_tmp,
            mail_domain: mail_domain_tmp,
            admin_users: this.admin_users
              .split("\n")
              .join(",")
              .toLowerCase()
              .trim(),
            workers_count: this.workers_count.toString(),
            auxiliary_account: this.isAuxiliaryAccountEnabled,
          },
          extra: {
            title: this.$t("settings.instance_configuration", {
              instance: this.instanceName,
            }),
            description: this.$t("settings.configuring"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // reload configuration
      this.getConfiguration();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.mg-bottom {
  margin-bottom: $spacing-06;
}

.maxwidth {
  max-width: 38rem;
}
</style>
