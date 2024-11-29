class EventModel{
  String eventname,detail,placename;
  DateTime? startdate,enddate;
  List<double>? latlng=[];

  EventModel({this.eventname='',this.placename='',this.detail='',this.startdate,this.enddate,this.latlng});
}