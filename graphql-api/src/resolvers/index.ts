import db from '../database';
import openFaasFunc from "./openfaas";
import kNativeFunc from "./knative";
import lambdaFunc from "./lambda"

export interface AsyncFunc {
  (parent: any, args: any, context: any, info: any): Promise<any>;
}
interface AsyncResolverFunc {
  (funcName: string): AsyncFunc;
}

export const asyncFunc: AsyncResolverFunc = lambdaFunc

function simpleFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    let data = db[funcName]
    if (parent && parent.id) {
      data = db[funcName][parent.id]
    }
    if (args && args.id) {
      return data.find(entity => entity.id === args.id);
    }
    return data;
  }
}

export const resolvers = {
  Query: {
    clients: asyncFunc('clients'),
    client: asyncFunc('clients'),
  },
  Client: {
    studies: asyncFunc('studies')
  },
  Study: {
    subjects: asyncFunc('subjects')
  },
  Subject: {
    visits: asyncFunc('visits')
  },
  Visit: {
    forms: asyncFunc('forms')
  }
};