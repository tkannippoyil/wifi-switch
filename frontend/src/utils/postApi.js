import axios from 'axios';
import { BASE_URL } from './config';

const postApi = (url, data = {}, callback, failed = () => {}) => {
  axios.post(`${BASE_URL + url}`, data)
    .then((response) => {
      callback(response.data);
    })
    .catch((e) => {
      console.warn(e);
      failed({
        error: 'Timeout',
        message: 'No of records is high',
      });
    });
};

export default postApi;
