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
#include "emcy.h"
#include "od.h"
#include "sdo.h"
#include <xccompat.h>

/*---------------------------------------------------------------------------
 Send Emergency message on to the CAN newtork
 ---------------------------------------------------------------------------*/
void emcy_send_emergency_message(streaming chanend c_rx_tx,
                                 can_state_t can_state,
                            char error_type,
                            unsigned emergency_code,
                            REFERENCE_PARAM(unsigned char, error_index_pointer),
                            REFERENCE_PARAM(char, canopen_state))
{
  can_frame_t frame;
  char data_buffer[4];
  char max_error_entries, max_error_behaviour_entries;
  char error_exists = 0, counter = 0;
  unsigned error_code;
  int index = od_find_index(ERROR_BEHAVIOUR_OBJECT);
  if (index != -1)
  {
    od_read_data(index, 0, data_buffer, 1);
    max_error_behaviour_entries = data_buffer[0];
    od_read_data(index, 1, data_buffer, 1);
    if (data_buffer[0] == ERR_SWITCH_TO_PRE_OPERATIONAL)
      canopen_state = PRE_OPERATIONAL;
    else if (data_buffer[0] == ERR_SWITCH_TO_STOPPED)
      canopen_state = STOPPED;
  }
  index = od_find_index(PRE_DEFINED_ERROR_FIELD_OBJECT);  //Error register
  if (index != -1)
  {
    od_read_data(index, 0, data_buffer, 1);
    max_error_entries = data_buffer[0];
    while(counter != max_error_entries)
    {
      od_read_data(index, counter, data_buffer, 2);
      error_code = (data_buffer[1] << 8) | data_buffer[0];
      if (error_code == emergency_code)
        error_exists = 1;
      counter++;
    }
    if (!error_exists)
    {
      if ((error_index_pointer > 0)
          && (error_index_pointer < max_error_entries))
      {
        data_buffer[1] = (emergency_code & 0x0000FF00) >> 8;
        data_buffer[0] = (emergency_code & 0x000000FF);
        od_write_data(index, error_index_pointer + 1, data_buffer, 2);
        error_index_pointer += 1;
        if (error_index_pointer > max_error_entries)
          error_index_pointer = 1;
      }
    }
  }
  index = od_find_index(PRE_DEFINED_ERROR_FIELD_OBJECT);
  if (index != -1)
  {
    od_read_data(index, error_index_pointer, data_buffer, 1);
    data_buffer[0] = data_buffer[0] | 0x01 << (error_type);
  }
  frame.dlc = 8;
  frame.extended = 0;
  frame.remote = 0;
  frame.id = EMERGENCY_MESSAGE + CANOPEN_NODE_ID;
  frame.data[0] = (emergency_code >> 8);
  frame.data[1] = emergency_code & 0xFF;
  frame.data[2] = data_buffer[0];
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  while(can_send(can_state, frame) != 0);
}


/*---------------------------------------------------------------------------
 Rest Error Register based on Reset command send by the CANOpen Master
 ---------------------------------------------------------------------------*/
void emcy_reset_error_register()
{
  int index = od_find_index(ERROR_BEHAVIOUR_OBJECT);
  char data_buffer[4] = {0, 0, 0, 0};
  char max_error_behaviour_entries, counter = 0;
  if (index != -1)
  {
    od_read_data(index, 0, data_buffer, 1);
    max_error_behaviour_entries = data_buffer[0];
    while(counter < max_error_behaviour_entries)
    {
      od_write_data(index, counter, data_buffer, 4);
      counter++;
    }
  }
}
