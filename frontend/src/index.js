import React from 'react';
import ReactDOM from 'react-dom';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import './index.css';
import AppRoute from './App';
import registerServiceWorker from './registerServiceWorker';

const App = () => (
  <MuiThemeProvider>
    <AppRoute />
  </MuiThemeProvider>
);

ReactDOM.render(
  <App />,
  document.getElementById('root'),
);
registerServiceWorker();
