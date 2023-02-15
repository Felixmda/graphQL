

import 'package:hasura_connect/hasura_connect.dart';

final String url = 'https://legal-flamingo-55.hasura.app/v1/graphql';
final String codeAdmin = 'jDcvwl360q8JeR0rXpxAuCcKRcPLZIcukih6Xms54COnXoiEp1T55TeQT4tqrU3r';

class CnxHasura {



 static  HasuraConnect hasuraConnect = HasuraConnect(url,
     headers: {"x-hasura-admin-secret" : codeAdmin,
      "content-type": "application/json"
 } );
}