import { AsyncFunc } from './index'
import axios from 'axios'
import { ApolloError } from 'apollo-server-errors';
import {stringify} from "querystring";

const URL = process.env.LAMBDA_URL

const http = axios.create({
  baseURL: `${URL}`,
  proxy: false,
  headers: {'Content-Type': 'application/json'}
});


export default function lambdaFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    const postBody = constructPostBodyWith(parent, args, context, info)
    console.log(`Calling ${funcName} ${http.defaults.baseURL}/${funcName}`)
    const r = http.get(funcName)
    r.catch((e) => {
      console.log(`FAILED: ${e}`)
    })
    const {data, headers, status, statusText} = await http.post(`${funcName}`, postBody, {responseType: "json"})
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