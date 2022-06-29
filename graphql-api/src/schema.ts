import {gql} from 'apollo-server';
import db from './database';

// A schema is a collection of type definitions (hence "typeDefs")
// that together define the "shape" of queries that are executed against
// your data.
export const typeDefs = gql`
    # Comments in GraphQL strings (such as this one) start with the hash (#) symbol.

    # This "Book" type defines the queryable fields for every book in our data source.
    type Client {
        id: ID!
        name: String!
        studies: [Study]
    }

    type Study {
        id: ID!
        name: String!
        description: String
        subjects: [Subject]
    }

    type Site {
        id: ID!
        name: String!
        address: String
    }

    type Subject {
        id: ID!
        site: Site!
        visits: [Visit]
    }

    type Visit {
        id: ID!
        name: String!
        forms: [Form]
    }

    type Form {
        id: ID!
        name: String!
    }

    # The "Query" type is special: it lists all of the available queries that
    # clients can execute, along with the return type for each. In this
    # case, the "books" query returns an array of zero or more Books (defined above).
    type Query {
        clients: [Client]
        client(id: ID!): Client
    }
`;

// Resolvers define the technique for fetching the types defined in the
// schema. This resolver retrieves books from the "books" array above.

export const resolvers = {
  Query: {
    clients: (parent, args, context, info) => db.clients,
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