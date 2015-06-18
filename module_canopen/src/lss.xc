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
#include <xccompat.h>
#include "canopen.h"
#include "lss.h"
#include "od.h"
#include "can_util.h"
#include "emcy.h"


/*---------------------------------------------------------------------------
 Send LSS node ID to the LSS master
 ---------------------------------------------------------------------------*/
void lss_send_node_id(streaming chanend c_rx_tx, can_state_t &can_state)
{
  can_frame_t frame;
  frame.dlc = 8;
  frame.id = TLSS_MESSAGE;
  frame.remote = 0;
  frame.extended = 0;
  frame.data[0] = INQUIRE_NODE_ID;
  frame.data[1] = CANOPEN_NODE_ID;
  frame.data[2] = 0;
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  can_send_blocking(c_rx_tx, can_state, frame);
}

/*---------------------------------------------------------------------------
 Configure LSS node id based on configure command send by the LSS master
 ---------------------------------------------------------------------------*/
void lss_configure_node_id_response(streaming chanend c_rx_tx, can_state_t &can_state, char configuration_status)
{
  can_frame_t frame;
  frame.dlc = 8;
  frame.id = TLSS_MESSAGE;
  frame.remote = 0;
  frame.extended = 0;
  frame.data[0] = CONFIGURE_NODE_ID;
  if (configuration_status == TRUE)
    frame.data[1] = 0;
  else
    frame.data[1] = 1;
  frame.data[2] = 0;
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  can_send_blocking(c_rx_tx, can_state, frame);
}

/*---------------------------------------------------------------------------
 Configure LSS bit time based on configure command send by the LSS master
 ---------------------------------------------------------------------------*/
void lss_configure_bit_timing_response(streaming chanend c_rx_tx,
                                       can_state_t &can_state,
                                       char configuration_status)
{
  can_frame_t frame;
  frame.dlc = 8;
  frame.id = TLSS_MESSAGE;
  frame.remote = 0;
  frame.extended = 0;
  frame.data[0] = CONFIGURE_BIT_TIMING_PARAMETERS;
  if (configuration_status == TRUE)
    frame.data[1] = 0;
  else
    frame.data[1] = 1;
  frame.data[2] = 0;
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  can_send_blocking(c_rx_tx, can_state, frame);
}

/*---------------------------------------------------------------------------
 Store LSS settings based on store command send by the LSS master
 ---------------------------------------------------------------------------*/
void lss_store_config_settings_response(streaming chanend c_rx_tx,
                                        can_state_t &can_state,
                                        char configuration_status)
{
  can_frame_t frame;
  frame.dlc = 8;
  frame.id = TLSS_MESSAGE;
  frame.remote = 0;
  frame.extended = 0;
  frame.data[0] = STORE_CONFIGURATION_SETTINGS;
  if (configuration_status == TRUE)
    frame.data[1] = 0;
  else
    frame.data[1] = 2;
  frame.data[2] = 0;
  frame.data[3] = 0;
  frame.data[4] = 0;
  frame.data[5] = 0;
  frame.data[6] = 0;
  frame.data[7] = 0;
  can_send_blocking(c_rx_tx, can_state, frame);
}

/*---------------------------------------------------------------------------
 Send LSS Vendor ID based on LSS master Inquiry
 ---------------------------------------------------------------------------*/
void lss_inquire_vendor_id_response(streaming chanend c_rx_tx,
                                    can_state_t &can_state,
                                    REFERENCE_PARAM(char, canopen_state),
                                    REFERENCE_PARAM(unsigned char,
                                                    error_index_pointer))
{
  int index = od_find_index(IDENTITY_OBJECT);
  char data_buffer[4];
  can_frame_t frame;
  if (index != -1)
  {
    od_read_data(index, 1, data_buffer, 4);
    frame.dlc = 8;
    frame.id = TLSS_MESSAGE;
    frame.remote = 0;
    frame.extended = 0;
    frame.data[0] = INQUIRE_VENDOR_ID;
    frame.data[1] = data_buffer[0];
    frame.data[2] = data_buffer[1];
    frame.data[3] = data_buffer[2];
    frame.data[4] = data_buffer[3];
    frame.data[5] = 0;
    frame.data[6] = 0;
    frame.data[7] = 0;
    can_send_blocking(c_rx_tx, can_state, frame);
  }
  else
  {
    emcy_send_emergency_message(c_rx_tx,
                                can_state,
                                ERR_TYPE_COMMUNICATION_ERROR,
                                PROTOCOL_ERROR_GENERIC,
                                error_index_pointer,
                                canopen_state);
  }
}

/*---------------------------------------------------------------------------
 Send LSS Product code based on LSS master Inquiry
 ---------------------------------------------------------------------------*/
void lss_inquire_product_code(streaming chanend c_rx_tx,
                              can_state_t &can_state,
                              REFERENCE_PARAM(char, canopen_state),
                              REFERENCE_PARAM(unsigned char,
                                              error_index_pointer))
{
  int index = od_find_index(IDENTITY_OBJECT);
  char data_buffer[4];
  can_frame_t frame;
  if (index != -1)
  {
    od_read_data(index, 2, data_buffer, 4);
    frame.dlc = 8;
    frame.id = TLSS_MESSAGE;
    frame.remote = 0;
    frame.extended = 0;
    frame.data[0] = INQUIRE_PRODUCT_CODE;
    frame.data[1] = data_buffer[0];
    frame.data[2] = data_buffer[1];
    frame.data[3] = data_buffer[2];
    frame.data[4] = data_buffer[3];
    frame.data[5] = 0;
    frame.data[6] = 0;
    frame.data[7] = 0;
    can_send_blocking(c_rx_tx, can_state, frame);
  }
  else
  {
    emcy_send_emergency_message(c_rx_tx,
                                can_state,
                                ERR_TYPE_COMMUNICATION_ERROR,
                                PROTOCOL_ERROR_GENERIC,
                                error_index_pointer,
                                canopen_state);
  }
}

/*---------------------------------------------------------------------------
 Send LSS Revision Number based on LSS master Inquiry
 ---------------------------------------------------------------------------*/
void lss_inquire_revision_number(streaming chanend c_rx_tx,
                                 can_state_t &can_state,
                                 REFERENCE_PARAM(char, canopen_state),
                                 REFERENCE_PARAM(unsigned char,
                                                 error_index_pointer))
{
  int index = od_find_index(IDENTITY_OBJECT);
  char data_buffer[4];
  can_frame_t frame;
  if (index != -1)
  {
    od_read_data(index, 3, data_buffer, 4);
    frame.dlc = 8;
    frame.id = TLSS_MESSAGE;
    frame.remote = 0;
    frame.extended = 0;
    frame.data[0] = INQUIRE_REVISION_NUMBER;
    frame.data[1] = data_buffer[0];
    frame.data[2] = data_buffer[1];
    frame.data[3] = data_buffer[2];
    frame.data[4] = data_buffer[3];
    frame.data[5] = 0;
    frame.data[6] = 0;
    frame.data[7] = 0;
    can_send_blocking(c_rx_tx, can_state, frame);
  }
  else
  {
    emcy_send_emergency_message(c_rx_tx,
                                can_state,
                                ERR_TYPE_COMMUNICATION_ERROR,
                                PROTOCOL_ERROR_GENERIC,
                                error_index_pointer,
                                canopen_state);
  }
}

/*---------------------------------------------------------------------------
 Send LSS Serial Number based on LSS master Inquiry
 ---------------------------------------------------------------------------*/
void lss_inquire_serial_number(streaming chanend c_rx_tx,
                               can_state_t &can_state,
                               REFERENCE_PARAM(char, canopen_state),
                               REFERENCE_PARAM(unsigned char,
                                               error_index_pointer))
{
  int index = od_find_index(IDENTITY_OBJECT);
  char data_buffer[4];
  can_frame_t frame;
  if (index != -1)
  {
    od_read_data(index, 4, data_buffer, 4);
    frame.dlc = 8;
    frame.id = TLSS_MESSAGE;
    frame.remote = 0;
    frame.extended = 0;
    frame.data[0] = INQUIRE_SERIAL_NUMBER;
    frame.data[1] = data_buffer[0];
    frame.data[2] = data_buffer[1];
    frame.data[3] = data_buffer[2];
    frame.data[4] = data_buffer[3];
    frame.data[5] = 0;
    frame.data[6] = 0;
    frame.data[7] = 0;
    can_send_blocking(c_rx_tx, can_state, frame);
  }
  else
  {
    emcy_send_emergency_message(c_rx_tx,
                                can_state,
                                ERR_TYPE_COMMUNICATION_ERROR,
                                PROTOCOL_ERROR_GENERIC,
                                error_index_pointer,
                                canopen_state);
  }
}

