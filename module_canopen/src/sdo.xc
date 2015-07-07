/**
* The copyrights, all other intellectual and industrial
* property rights are retained by XMOS and/or its licensors.
* Terms and conditions covering the use of this code can
* be found in the Xmos End User License Agreement.
*
* Copyright XMOS Ltd 2012
*
* In the case where this code is a modification of existing code
* under a separate license, the separate license terms are shown
* below. The modifications to the code are still covered by the
* copyright notice above.
*
**/

/*---------------------------------------------------------------------------
 include files
 ---------------------------------------------------------------------------*/
#include "canopen.h"

/*---------------------------------------------------------------------------
 Upload Expedited Data
 ---------------------------------------------------------------------------*/
void sdo_upload_expedited_data(streaming chanend c_rx_tx,
                               can_state_t can_state,
                           int od_index,
                           char od_sub_index,
                           char data_length,
                           char data_buffer[])
{
  char count = 0;
  can_frame_t frame;
  if (data_length <= 4)
  {
    frame.id = TSDO_MESSAGE;
    frame.extended = 0;
    frame.remote = 0;
    frame.dlc = 8;
    frame.data[0] = 0x43 | ((4 - data_length) << 2);
    frame.data[1] = od_index & 0xFF;
    frame.data[2] = (od_index & 0xFF00) >> 8;
    frame.data[3] = od_sub_index;
    while(count != 4)
    {
      if (count < data_length)
        frame.data[count + 4] = data_buffer[(int)count];
      else
        frame.data[count + 4] = 0;
      count++;
    }
    while(can_send(can_state, frame) != 0);
  }
}

/*---------------------------------------------------------------------------
 Send Download Response
 ---------------------------------------------------------------------------*/
void sdo_send_download_response(int od_index,
                                char od_sub_index,
                                streaming chanend c_rx_tx,
                                can_state_t can_state)
{
  can_frame_t frame;
  frame.id = TSDO_MESSAGE;
  frame.extended = 0;
  frame.remote = 0;
  frame.dlc = 8;
  frame.data[0] = 0b01100000;
  frame.data[1] = od_index & 0xFF;
  frame.data[2] = (od_index & 0xFF00) >> 8;
  frame.data[3] = od_sub_index;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  while(can_send(can_state, frame) != 0);
}

/*---------------------------------------------------------------------------
 Download SDO Segmented Data
 ---------------------------------------------------------------------------*/
void sdo_download_segment_response(streaming chanend c_rx_tx, can_state_t can_state, char sdo_toggle)
{
  can_frame_t frame;
  frame.id = TSDO_MESSAGE;
  frame.extended = 0;
  frame.remote = 0;
  frame.dlc = 8;
  frame.data[0] = (((0x01 << 1) | sdo_toggle) << 4); //set toggle bit
  frame.data[1] = 0;
  frame.data[2] = 0;
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  while(can_send(can_state, frame) != 0);
}

/*---------------------------------------------------------------------------
 Initiate SDO Upload Response
 ---------------------------------------------------------------------------*/
void sdo_initiate_upload_response(streaming chanend c_rx_tx,
                                  can_state_t can_state,
                                  int od_index,
                                  char od_sub_index,
                                  char data_length)
{
  can_frame_t frame;
  frame.id = TSDO_MESSAGE;
  frame.extended = 0;
  frame.remote = 0;
  frame.dlc = 8;
  frame.data[0] = 0x41; //initial upload response
  frame.data[1] = od_index & 0xFF;
  frame.data[2] = (od_index & 0xFF00) >> 8;
  frame.data[3] = od_sub_index;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  while(can_send(can_state, frame) != 0);
}

/*---------------------------------------------------------------------------
 Upload Segmented Data
 ---------------------------------------------------------------------------*/
void sdo_upload_segmented_data(streaming chanend c_rx_tx,
                               can_state_t can_state,
                           int od_index,
                           char od_sub_index,
                           char sdo_toggle,
                           char data_length,
                           char data_buffer[],
                           char segment_number)
{
  can_frame_t frame;
  char no_of_segments = 0, no_of_data_bytes, counter = 0;
  if (data_length % 7 == 0)
    no_of_segments = data_length / 7;
  else
    no_of_segments = (data_length / 7) + 1;
  if (segment_number == no_of_segments - 1)
  {
    if(data_length != 7)
      no_of_data_bytes = data_length % 7;
    else
      no_of_data_bytes = 7;
    while(counter != 7)
    {
      if (counter < no_of_data_bytes)
      {
        frame.data[counter + 1] = data_buffer[(segment_number * 7) + counter];
      }
      else
        frame.data[counter + 1] = 0;
      counter++;
    }
  }
  else
  {
    frame.data[1] = data_buffer[segment_number * 7];
    frame.data[2] = data_buffer[(segment_number * 7) + 1];
    frame.data[3] = data_buffer[(segment_number * 7) + 2];
    frame.data[4] = data_buffer[(segment_number * 7) + 3];
    frame.data[5] = data_buffer[(segment_number * 7) + 4];
    frame.data[6] = data_buffer[(segment_number * 7) + 5];
    frame.data[7] = data_buffer[(segment_number * 7) + 6];
  }
  frame.id = TSDO_MESSAGE;
  frame.extended = 0;
  frame.remote = 0;
  frame.dlc = 8;
  frame.data[0] = 0x00 | (sdo_toggle << 4);
  while(can_send(can_state, frame) != 0);
}

/*---------------------------------------------------------------------------
 Transmit SDO Abort code
 ---------------------------------------------------------------------------*/
void sdo_send_abort_code(int index, char si, unsigned error, streaming chanend c_rx_tx, can_state_t can_state)
{
  can_frame_t frame;
  frame.dlc = 8;
  frame.extended = 0;
  frame.remote = 0;
  frame.id = TSDO_MESSAGE ;
  frame.data[0] = EMERGENCY_MESSAGE;
  frame.data[1] = index & 0xFF;
  frame.data[2] = ((index >> 8) & 0xFF);
  frame.data[3] = si;
  frame.data[4] = (error & 0xFF);
  frame.data[5] = ((error >> 8) & 0xFF);
  frame.data[6] = ((error >> 16) & 0xFF);
  frame.data[7] = ((error >> 24) & 0xFF);
  while(can_send(can_state, frame) != 0);
}
