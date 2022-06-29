import { ApolloServer } from 'apollo-server';
import { typeDefs, resolvers } from "./schema";
import { asyncFuncResolvers} from "./resolvers";

// The ApolloServer constructor requires two parameters: your schema
// definition and your set of resolvers.
const server = new ApolloServer({
  typeDefs,
  // resolvers,
  resolvers: asyncFuncResolvers,
  csrfPrevention: true,
  cache: 'bounded',
});

// The `listen` method launches a web server.
server.listen().then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});