import Cookies from 'universal-cookie';

const cookies = new Cookies();

/**
 * [makeParameters prepared the header for requests]
 * @method makeParameters
 * @param  {[string]}       method        [request method]
 * @param  {[object]}       customHeaders [description]
 * @return {[type]}                     [description]
 */
function makeParameters(method, customHeaders) {
  let ACCESSTOKEN;
  let REQUESTUSER;
  try {
    const userInfo = cookies.get('userInfo');
    ACCESSTOKEN = userInfo.token;
    REQUESTUSER = userInfo.user_id;
  } catch (e) {
    ACCESSTOKEN = null;
    REQUESTUSER = null;
  }

  const preHeaders = {
    Accept: 'application/json',
    'content-type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    Origin: '*',
    'REQUEST-USER': '8',
    'ACCESS-TOKEN':
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Imd0b255QHN1eWF0aS5jb20iLCJleHAiOjE1MDgyMzExMzgsImRldmljZV9pZCI6IjIyMy4zMC4xMi4xNjYifQ.WKtR5hq2ZHLNUScD8y-HDG1YpjuH_JXrGJPz9BW9s3g',
  };
  if (ACCESSTOKEN) preHeaders['ACCESS-TOKEN'] = ACCESSTOKEN;
  if (REQUESTUSER) preHeaders['REQUEST-USER'] = REQUESTUSER;
  const headers = Object.assign(
    { 'content-type': 'application/json', Accept: 'application/json' },
    preHeaders,
    customHeaders,
  );
  return Object.assign({ method, headers });
}

export default makeParameters;
