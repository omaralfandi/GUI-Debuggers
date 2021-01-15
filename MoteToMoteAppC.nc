configuration MoteToMoteAppC{
 // Not Intrested Now!!
}
implementation{
 //General
 components MoteToMoteC as App; //Main module file
 components MainC; //Boot
 components LedsC; //Leds
 App.Boot -> MainC;
 App.Leds -> LedsC;

 //Radio Communication
 components ActiveMessageC;
 components new AMSenderC(AM_RADIO);
 components new AMReceiverC(AM_RADIO);
 App.Packet -> AMSenderC;
 App.AMPacket-> AMSenderC;
 App.AMSend -> AMSenderC;
 App.AMControl -> ActiveMessageC;
 App.Receive -> AMReceiverC;
}
