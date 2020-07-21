// Copyright (c) Microsoft. All rights reserved.

import React from "react";
import { toDiagnosticsModel } from "services/models";
import { svgs, LinkedComponent } from "utilities";
import { BtnToolbar, Btn, Flyout, DeleteModal } from "components/shared";
import { Toggle } from "@microsoft/azure-iot-ux-fluent-controls/lib/components/Toggle";

import "./deploymentStatus.scss";

export class DeploymentStatus extends LinkedComponent {
    constructor(props) {
        super(props);

        this.state = {
            selectedDeployment: {},
            gridData: [],
            isActive: false,
            haschanged: false,
        };
    }

    genericCloseClick = (eventName) => {
        const { onClose, logEvent } = this.props;
        logEvent(toDiagnosticsModel(eventName, {}));
        onClose();
    };

    componentDidMount() {
        if (this.props.selectedDeployment) {
            this.setState({
                isActive: this.props.selectedDeployment.isActive,
            });
        }
    }

    onDelete = () => {
        this.closeModal();
        this.props.history.push("/deployments");
    };

    onDeploymentStatusChange = (updatedStatus) => {
        setTimeout(() => {
            if (this.state.isActive !== updatedStatus) {
                this.setState({
                    isActive: updatedStatus,
                    haschanged: true,
                });
            }
        }, 10);
    };

    apply = (event) => {
        event.preventDefault();
        if (this.state.haschanged) {
            if (this.state.isActive) {
                this.props.reactivateDeployment(
                    this.props.selectedDeployment.id
                );
            } else {
                this.props.deleteItem(this.props.selectedDeployment.id);
            }
        }
    };

    render() {
        const { hasChanged } = this.state;
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
                    <div>
                        {t("deployments.flyouts.status.deploymentLimitText")}
                    </div>
                    <br />
                    <h3>{this.props.selectedDeployment.name}</h3>
                    <br />
                    <Toggle
                        className="simulation-toggle-button"
                        name={t("this.props.selectedDeployment.name")}
                        attr={{
                            button: {
                                "aria-label": t(
                                    "settingsFlyout.simulationToggle"
                                ),
                                type: "button",
                            },
                        }}
                        // on={this.props.selectedDeployment.isActive}
                        on={this.state.isActive}
                        onLabel={t("deployments.flyouts.status.active")}
                        offLabel={t("deployments.flyouts.status.inActive")}
                        onChange={this.onDeploymentStatusChange}
                    />
                    <br />
                    <br />
                    <form className="new-deployment-form" onSubmit={this.apply}>
                        <div>
                            <h3>
                                {t(
                                    "deployments.flyouts.status.relatedDeployment.title"
                                )}
                            </h3>
                        </div>
                        <div>
                            {this.props.relatedDeployments.length === 0 && (
                                <div>
                                    {t(
                                        "deployments.flyouts.status.relatedDeployment.noRelatedDeploymentText"
                                    )}
                                </div>
                            )}
                            <ul>
                                {this.props.relatedDeployments.map(
                                    (deployment) => {
                                        return (
                                            <li key={deployment.id}>
                                                {deployment.name}
                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                {
                                                    deployment.createdDateTimeUtc
                                                }{" "}
                                                &nbsp;-&nbsp;
                                                {deployment.modifiedDate}
                                                <br />
                                            </li>
                                        );
                                    }
                                )}
                            </ul>
                        </div>
                        <div>
                            <BtnToolbar>
                                <Btn
                                    primary={true}
                                    type="submit"
                                    disabled={!this.state.haschanged}
                                >
                                    {t("deployments.flyouts.status.apply")}
                                </Btn>
                                <Btn
                                    svg={svgs.cancelX}
                                    onClick={() =>
                                        this.genericCloseClick(
                                            "DeploymentStatus_CloseClick"
                                        )
                                    }
                                >
                                    {hasChanged
                                        ? t("deployments.flyouts.status.cancel")
                                        : t("deployments.flyouts.status.close")}
                                </Btn>
                            </BtnToolbar>
                        </div>
                    </form>
                </div>
            </Flyout>
        );
    }
}
