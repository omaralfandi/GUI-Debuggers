#include"MoteToMoteh.h"
module MoteToMoteC
{
 uses interface Boot;
 uses interface Leds;
 uses interface Packet;
 uses interface AMPacket;
 uses interface AMSend;
 uses interface SplitControl as AMControl;
 uses interface Receive;
}
implementation
{
uint16_t counter;
message_t _packet;
bool busy = FALSE;
 event void Boot.booted(){
 call AMControl.start();
 }
 event void AMControl.stopDone(error_t error)
 {

 }
 event void AMControl.startDone(error_t error)
 {
 if(busy == FALSE)
 {
 //creating the packet
 MoteToMoteMsg_t* msg = call Packet.getPayload(& _packet,
sizeof(MoteToMoteMsg_t));
 msg -> NodeId = TOS_NODE_ID;
 msg -> Data = (uint8_t)error;

 //sending the packet
 if (call AMSend.send(AM_BROADCAST_ADDR, & _packet,
sizeof(MoteToMoteMsg_t))==SUCCESS);

 if(error == SUCCESS)
 {
 call Leds.led0On();
 }
 else
 {
 call AMControl.start();
 }
 }

 }
 event void AMSend.sendDone(message_t *msg, error_t error)
 {
 if(msg == & _packet)
 {
 busy = FALSE;
 }
 }
 event message_t * Receive.receive(message_t *msg, void *payload, uint8_t len){

 if(len == sizeof(MoteToMoteMsg_t))
 {
 MoteToMoteMsg_t * incomingPacket = (MoteToMoteMsg_t*) payload;
 uint8_t data = incomingPacket -> Data;
 if(data == 1)
 {
 call Leds.led2On();
 }
 if(data == 0)
 {
 call Leds.led2Off();
 }
 }
 return msg;
 }
}
