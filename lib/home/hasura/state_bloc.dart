
abstract class StateBloc{


}

class StatusSuccess implements StateBloc {
  final dynamic data;
  StatusSuccess(this.data);

}
class StatusLoading implements StateBloc {

}
class StatusError implements StateBloc {
  final String message;
  StatusError(this.message);

}
class StatusNullable implements StateBloc {

}

