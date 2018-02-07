let BASE_URL = 'http://35.192.166.241:3001/api/v1/';

if(process.env.NODE_ENV !== 'production'){
  BASE_URL = 'http://35.192.166.241:3001/api/v1/';
}

export { BASE_URL };
