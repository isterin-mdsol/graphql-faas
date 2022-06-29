import db from './database';

interface AsyncFunc {
  (parent: any, args: any, context: any, info: any): Promise<any>;
}
interface AsyncResolverFunc {
  (funcName: string): AsyncFunc;
}

function simpleFunc(funcName: string): AsyncFunc {
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
    client: (parent, args, context, info) => {
      return db.clients.find(client => client.id === args.id);
    }
  },
  Client: {
    studies: (client) => {
      return db.clientStudies[client.id];
    }
  },
  Study: {
    subjects: (study) => {
      return db.studySubjects[study.id];
    }
  },
  Subject: {
    visits: (subject) => {
      return db.subjectVisits[subject.id];
    }
  },
  Visit: {
    forms: (visit) => {
      return db.visitForms[visit.id];
    }
  }
};

// class OpenFaaSFunc implements AsyncResolver {
//   async (parent: any, args: {}, context: any, info: any): any {
//     return {};
//   }
// }
//
// class KNativeFunc implements AsyncResolver {
//   async (parent: any, args: {}, context: any, info: any): any {
//     return {};
//   }
// }
