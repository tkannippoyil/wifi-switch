import axios from 'axios';
import { BASE_URL } from './config';

function urlString(obj) {
  return `?${Object.keys(obj)
    .map(k => `${k}=${encodeURIComponent(obj[k])}`)
    .join('&')}`;
}

const getApi = (url, query = {}, callback, failed = () => {}) => {
  const queryValues = { ...query};
  const URL = Object.keys(queryValues).length
    ? url + urlString(queryValues)
    : url;
  axios.get(`${BASE_URL + URL}`)
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

export default getApi;
