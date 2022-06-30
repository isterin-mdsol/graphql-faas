import db from './database';

interface AsyncFunc {
  (parent: any, args: any, context: any, info: any): Promise<any>;
}
interface AsyncResolverFunc {
  (funcName: string): AsyncFunc;
}

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

function openFaasFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    if (parent && parent.id) {
      return db[funcName][parent.id]
    }
    else if (args && args.id) {
      return db[funcName].find(entity => entity.id === args.id);
    }
    return db[funcName];
  }
}

function kNativeFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    if (parent && parent.id) {
      return db[funcName][parent.id]
    }
    else if (args && args.id) {
      return db[funcName].find(entity => entity.id === args.id);
    }
    return db[funcName];
  }
}

export const asyncFunc: AsyncResolverFunc = simpleFunc


export const asyncFuncResolvers = {
  Query: {
    clients: asyncFunc('clients'),
    client: asyncFunc('clients'),
  },
  Client: {
    studies: asyncFunc('clientStudies')
  },
  Study: {
    subjects: asyncFunc('studySubjects')
  },
  Subject: {
    visits: asyncFunc('subjectVisits')
  },
  Visit: {
    forms: asyncFunc('visitForms')
  }
};