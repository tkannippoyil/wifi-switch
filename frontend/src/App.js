import React, { Component } from 'react';
import {
  TimePicker,
  Checkbox,
  AppBar,
} from 'material-ui';
import RaisedButton from 'material-ui/RaisedButton';
import DeviceList from './components/DeviceList/DeviceList';
import getApi from './utils/getApi';
import postApi from './utils/postApi';
import './App.css'

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      devices: [],
      hour: '',
      minutes: '',
      repeat: false,
      monday: false,
      tuesday: false,
      wednesday: false,
      thursday: false,
      friday: false,
      saturday: false,
      sunday: false,
    };
    this.onSuccess = this.onSuccess.bind(this);
    this.onToggle = this.onToggle.bind(this);
    this.onClick = this.onClick.bind(this);
    this.onTurnOffAll = this.onTurnOffAll.bind(this);
    this.onTurnOnAll = this.onTurnOnAll.bind(this);
    this.onToggleAll = this.onToggleAll.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
    this.checkStatus = this.checkStatus.bind(this);
    this.onResult = this.onResult.bind(this);
  }
  componentDidMount() {
    console.log(process.env.NODE_ENV);
    getApi('devices', {}, this.onSuccess);
  }

  onSuccess(response) {
    this.setState({ devices: response });
    console.log(response);
  }

  checkStatus(){
    // const stat = setInterval(getStatus(), 1000);
    // function getStatus() {
    //   getApi('devices', {}, (resp) => this.onResult(resp, stat));
    // }
    setTimeout(() => { getApi('devices', {}, this.onSuccess) }, 1000);
  }

  onResult(response, stat) {

    // let remove = true;
    // response.map((device) => {
    //   if (device.processing) {
    //     remove = false;
    //   }
    // });
    // if (remove) {
    //   console.log("devices", response);
    //   this.setState({ devices: response });
    //   clearInterval(stat);
    // }
  }

  onClick(address) {
    getApi('devices/' + address + '/restart', {}, () => console.log("restart"));
  }

  onTurnOnAll() {
    console.log('Turn on');
    getApi('devices/turn_on_all', {}, this.onSuccess);
    this.checkStatus();
  }

  onTurnOffAll() {
    console.log('Turn off');
    getApi('devices/turn_off_all', {}, this.onSuccess);
    this.checkStatus();
  }

  onToggleAll() {
    console.log('Toggle');
    getApi('devices/toggle_all', {}, this.onSuccess);
    this.checkStatus();
  }

  onSubmit() {
    console.log('Toggle');
    const data = {
      name: 'blah',
      hour: '12',
      minutes: '30',
      repeat: true,
      repeat_days: [{"day":1, "run":false}, {"day":2, "run":false}, {"day":3, "run":false}, {"day":4, "run":false}, {"day":5, "run":false}, {"day":6, "run":false}, {"day":7, "run":false}],
      device_id: null,
    }
    postApi('devices/toggle_all', data, this.onSuccess);
  }

  onToggle(address, turnOn) {
    if (turnOn) {
      getApi('devices/' + address + '/turn_on', {}, () => console.log("turn_on"));
    } else {
      getApi('devices/' + address + '/turn_off', {}, () => console.log("turn_off"));
    }
    this.checkStatus();
  }

  handleChange = (event, date) => {
    this.setState({value: date});
  };

  handleCheck = (name) => {
    this.setState((oldState) => {
      return {
        [name]: !oldState[name],
      };
    });
  };

  render() {
    const days = [
      { day: 'monday', disp: 'MON' },
      { day: 'tuesday', disp: 'TUE' },
      { day: 'wednesday', disp: 'WED' },
      { day: 'thursday', disp: 'THU' },
      { day: 'friday', disp: 'FRI' },
      { day: 'saturday', disp: 'SAT' },
      { day: 'sunday', disp: 'SUN' }];
    return (
      <div>
        <AppBar
          title="WATTBox Switch"
          showMenuIconButton={false}
          style={{ position: 'fixed', marginTop: '0', flexWrap: 'wrap' }}
        />
        <div className="container">
        <div className="device-main">
          {/* <div className="row">
            <div className="col-xs-6 center">
              <RaisedButton
                label="Turn on All"
                onClick={this.onTurnOnAll}
              />
            </div>
            <div className="col-xs-6 center">
              <RaisedButton
                label="Turn off All"
                onClick={this.onTurnOffAll}
              />
            </div>
          </div> */}
          {/* <div className="row">
            <div className="col-xs-4 center">
              <RaisedButton
                label="Toggle"
                onClick={this.onToggleAll}
              />
            </div>
          </div> */}
        </div>
        <hr />
        {this.state.devices.length > 0 &&
          <DeviceList
          onToggle={this.onToggle}
          onClick={this.onClick}
          devices={this.state.devices}
        />}
        <hr />
        {/* <div className="row">
          <div className="col-sm-12">
            <div className="row">
              <TimePicker
                format="ampm"
                hintText="12hr Format"
                value={this.state.value}
                onChange={this.handleChange}
              />
            </div>
            <div className="row">
              <Checkbox
                label="Repeat"
                checked={this.state.repeat}
                onCheck={() =>this.handleCheck('repeat')}
              />
            </div>
            {this.state.repeat &&
              <div className="row">
                { days.map( (day) =>
                  <span>
                    <Checkbox
                      checkedIcon={<span><b>{day.disp}</b></span>}
                      uncheckedIcon={<span>{day.disp}</span>}
                      onCheck={() => this.handleCheck(day.day)}
                    />
                  </span>
                )}
              </div>
            }
            <RaisedButton
              label="Submit"
              onClick={this.onSubmit}
            />
          </div>
        </div> */}
      </div>
      </div>
    );
  }
}

export default App;
