import { AsyncFunc } from './index'
import axios from 'axios'
import { ApolloError } from 'apollo-server-errors';
import {stringify} from "querystring";

const getUrl = (funcName: string) => {
  return `http://knative-${funcName}-resolver.default.127.0.0.1.sslip.io`
}
const http = axios.create({
  headers: {'content-type': 'application/json'}
});


export default function kNativeFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    const postBody = constructPostBodyWith(parent, args, context, info)
    const {data, headers, status, statusText} = await http.post(getUrl(funcName), postBody, {responseType: "json"})
    console.log("DATA", data)
    console.log(`RETURNED: ${status} - ${statusText} ${typeof data})`, data)
    if (status != 200) {
      throw new ApolloError(statusText);
    }
    try {
      return typeof data === 'string' ? JSON.parse(data) : data
    }
    catch(e) {
      throw new ApolloError((e as Error).message);
    }
  }
}

function constructPostBodyWith(parent: any, args: any, context: any, info: any) {
  return { parent: parent || {}, args: args || {}, context: context || {}, info: info || {} }
}