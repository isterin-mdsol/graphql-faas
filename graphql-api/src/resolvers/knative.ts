import { AsyncFunc } from "./index"

export function kNativeFunc(funcName: string): AsyncFunc {
  return async function(parent: any, args: any, context: any, info: any): Promise<any>  {
    return null
  }
}