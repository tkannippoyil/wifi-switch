import React from 'react'
import Checkbox from 'material-ui/Checkbox';
import LightIcon from 'material-ui/svg-icons/action/lightbulb-outline';
import DeviceActions from './DeviceActions';
import getApi from '../../utils/getApi';
import Fan from './fan-512.png'

class DeviceList extends React.Component {
  constructor(props) {
    super(props);
    this.onToggle = this.onToggle.bind(this);
    //this.onSuccess = this.onSuccess.bind(this);
  }

  // onSuccess(response, stat){
  //   let devices = this.state;
  //   if(!response.processing){
  //     clearInterval(stat);
  //     var i = devices.findIndex(o => o.id === response.id);
  //     if (devices[i]) {
  //       devices[i] = response;
  //     }
  //     this.setState({ devices: devices });
  //   }
  // }

  onToggle(address, status) {
    this.props.onToggle(address, status);
    // const stat = setInterval(getStatus(address), 2000)
    // function getStatus(address) {
    //   getApi('devices/' + address + '/status', {}, (resp) => this.onSuccess(resp, stat));
    // }
  }

  render() {
    const devices = this.props.devices.sort((a,b) => a.id > b.id);
    return (
      <div className="device-list">
        {
          devices.length > 0 &&
          devices.map(device =>
            <div className="paper-div">
              <div className="row">
                <div className="col-xs-3">
                  {device.name !== "Light" ?
                    <Checkbox
                      checked={device.status}
                      onCheck={() => this.onToggle(device.address, !device.status)}
                      checkedIcon={<LightIcon style={{ height: '48px', width: '48px' }}/>}
                      uncheckedIcon={<LightIcon style={{ height: '48px', width: '48px' }}/>}
                    />  :
                    <Checkbox
                      checked={device.status}
                      onCheck={() => this.onToggle(device.address, !device.status)}
                      checkedIcon={<img id="running" src={Fan} style={{ height: '48px', width: '48px' }}/>}
                      uncheckedIcon={<img src={Fan} style={{ height: '48px', width: '48px' }}/>}
                    />
                  }
                </div>
                <div className="col-xs-6">
                  <div className="row">
                    {device.name ? device.name : `Device ${device.id}`}
                  </div>
                  <div className="row">
                    {device.status ? "ON" : "OFF"}
                  </div>
                </div>
                <div className="col-xs-3">
                  <DeviceActions
                    device={device}
                    status={device.status}
                    onToggle={this.props.onToggle}
                    onClick={this.props.onClick}
                  />
                </div>
              </div>
            </div>
          )
        }
      </div>
    );
  }
}

export default DeviceList;
