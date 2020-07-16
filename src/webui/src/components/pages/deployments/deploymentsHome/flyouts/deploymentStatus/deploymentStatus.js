// Copyright (c) Microsoft. All rights reserved.

import React from "react";
import { toDiagnosticsModel } from "services/models";
import { LinkedComponent } from "utilities";
import { Flyout } from "components/shared";

import "./deploymentStatus.scss";

export class DeploymentStatus extends LinkedComponent {
    constructor(props) {
        super(props);

        this.state = {
            packageType: "",
        };
    }

    apply = (event) => {
        event.preventDefault();
        if (this.formIsValid()) {
        }
    };

    formIsValid = () => {
        return [
            this.packageTypeLink,
            this.nameLink,
            this.priorityLink,
            this.packageIdLink,
        ].every((link) => !link.error);
    };

    genericCloseClick = (eventName) => {
        const { onClose, logEvent } = this.props;
        logEvent(toDiagnosticsModel(eventName, {}));
        onClose();
    };

    render() {
        const { t } = this.props;
        return (
            <Flyout
                header={t("deployments.flyouts.status.title")}
                t={t}
                onClose={() =>
                    this.genericCloseClick("DeploymentStatus_CloseClick")
                }
            >
                <div className="new-deployment-content">
                    <form
                        className="new-deployment-form"
                        onSubmit={this.apply}
                    ></form>
                </div>
            </Flyout>
        );
    }
}
