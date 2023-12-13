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
            <cv-form  v-show="!loading.getConfiguration" @submit.prevent="configureModule">
              <cv-text-input
                :label="$t('settings.roundcubemail_fqdn')"
                placeholder="roundcubemail.example.org"
                v-model.trim="host"
                class="mg-bottom"
                :invalid-message="$t(error.host)"
                :disabled="loading.getConfiguration || loading.configureModule"
                ref="host"
              >
              </cv-text-input>
              <cv-toggle
                value="letsEncrypt"
                :label="$t('settings.lets_encrypt')"
                v-model="isLetsEncryptEnabled"
                :disabled="loading.getConfiguration || loading.configureModule"
                class="mg-bottom"
              >
                <template slot="text-left">{{
                  $t("settings.disabled")
                }}</template>
                <template slot="text-right">{{
                  $t("settings.enabled")
                }}</template>
              </cv-toggle>
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
                :disabled="loading.getConfiguration || loading.configureModule"
                tooltipAlignment="start"
                tooltipDirection="top"
                ref="mail_server"
              >
                <template slot="tooltip">
                  {{ $t("settings.choose_the_mail_server_to_use") }}
                </template>
              </NsComboBox>
              <NsComboBox
                v-model.trim="ldap_domain"
                :autoFilter="true"
                :autoHighlight="true"
                :title="$t('settings.ldap_domain')"
                :label="$t('settings.choose_ldap_domain')"
                :options="user_domains_list"
                :userInputLabel="core.$t('settings.choose_ldap_domain')"
                :acceptUserInput="false"
                :showItemType="true"
                :invalid-message="$t(error.ldap_domain)"
                :disabled="loading.getConfiguration || loading.configureModule"
                tooltipAlignment="start"
                tooltipDirection="top"
                ref="ldap_domain"
              >
                <template slot="tooltip">
                  {{
                    $t("settings.choose_the_ldap_domain_to_authenticate_users")
                  }}
                </template>
              </NsComboBox>
              <!-- advanced options -->
              <cv-accordion ref="accordion" class="maxwidth mg-bottom">
                <cv-accordion-item :open="toggleAccordion[0]">
                  <template slot="title">{{
                    $t("settings.advanced")
                  }}</template>
                  <template slot="content">
                    <!-- <cv-text-input
                    :label="$t('settings.plugins')"
                    :placeholder="$t('settings.placeholder_plugins')"
                    v-model.trim="plugins"
                    class="mg-bottom"
                    :invalid-message="$t(error.plugins)"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="plugins"
                  >
                  </cv-text-input>
                  <cv-text-input
                    :label="$t('settings.upload_max_filesize')"
                    placeholder="5"
                    v-model.trim="upload_max_filesize"
                    class="mg-bottom"
                    :invalid-message="$t(error.upload_max_filesize)"
                    :disabled="
                      loading.getConfiguration || loading.configureModule
                    "
                    ref="upload_max_filesize"
                  >
                  </cv-text-input> -->
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
              <NsButton
                kind="primary"
                :icon="Save20"
                :loading="loading.configureModule"
                :disabled="loading.getConfiguration || loading.configureModule"
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
      urlCheckInterval: null,
      host: "",
      isLetsEncryptEnabled: false,
      ldap_domain: "",
      mail_server: "",
      mail_domain: "",
      mail_server_URL: [],
      user_domains_list: [],
      loading: {
        getConfiguration: false,
        configureModule: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        host: "",
        lets_encrypt: "",
        http2https: "",
        mail_server: "",
        ldap_domain: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
  },
  created() {
    this.getConfiguration();
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
      // force to reload mail_server value after dom update
      this.$nextTick(() => {
        const mail_server_tmp = config.mail_server;
        const mail_domain_tmp = config.mail_domain;
        if (mail_server_tmp && mail_domain_tmp) {
          this.mail_server = mail_server_tmp + "," + mail_domain_tmp;
        } else {
          this.mail_server = "";
        }
        this.ldap_domain = config.ldap_domain;
      });

      this.mail_server_URL = config.mail_server_URL;
      this.user_domains_list = config.user_domains_list;
      this.loading.getConfiguration = false;
      this.focusElement("host");
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
      if (!this.ldap_domain) {
        this.error.mail_server = "common.required";

        if (isValidationOk) {
          this.focusElement("ldap_domain");
        }
        isValidationOk = false;
      }
      return isValidationOk;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        // set i18n error message
        this.error[param] = this.$t("settings." + validationError.error);

        if (!focusAlreadySet) {
          this.focusElement(param);
          focusAlreadySet = true;
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
            mail_server: mail_server_tmp,
            mail_domain: mail_domain_tmp,
            ldap_domain: this.ldap_domain,
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
