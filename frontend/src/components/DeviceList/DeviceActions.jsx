import React from 'react';
import Checkbox from 'material-ui/Checkbox';
import IconButton from 'material-ui/IconButton';
import Refresh from 'material-ui/svg-icons/navigation/refresh';
import Light from 'material-ui/svg-icons/action/lightbulb-outline';

class DeviceActions extends React.Component {
  constructor(props) {
    super(props);
    this.onToggle = this.onToggle.bind(this);
  }

  onToggle(e, status) {
    e.preventDefault();
    console.log(status);
    this.props.onToggle(this.props.device.address, status)
  }

  render () {
    return (
      <div className="row">
        <div className="col-sm-6">
          <IconButton
            tooltip="Restart"
            disabled={!this.props.status}
            onClick={() => this.props.onClick(this.props.device.address)}
          >
            <Refresh />
          </IconButton>
        </div>
      </div>
    );
  }
}

export default DeviceActions;
