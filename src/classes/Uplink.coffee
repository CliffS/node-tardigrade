FFI = require 'ffi-napi'
Ref = require 'ref-napi'
Struct = require 'ref-struct-napi'
Path = require 'path'

UplinkConfig = Struct
  Volatile: Struct
    tls: Struct
      skip_peer_ca_whitelist: 'bool'
      peer_ca_whitelist_path: 'pointer'
    peer_id_version: 'pointer'
    max_inline_size: 'int32'
    max_memory: 'int32'
    dial_timeout: 'int32'
    user_agent: 'pointer'

UplinkConfigPtr = Ref.refType UplinkConfig

storj = FFI.Library 'libuplink/libuplinkc',
  new_uplink: [
    'long', [ UplinkConfigPtr, 'pointer', 'pointer' ]
  ]

class Uplink

  constructor: ->
    uplinkConfig = new UplinkConfig
    uplinkConfig.Volatile.tls.skip_peer_ca_whitelist = false
    uplinkConfig.Volatile.tls.peer_ca_whitelist_path = Ref.NULL
    uplinkConfig.Volatile.peer_id_version = Ref.NULL
    uplinkConfig.Volatile.max_inline_size = 0
    uplinkConfig.Volatile.max_memory = 0
    uplinkConfig.Volatile.dial_timeout = 0

    err = Buffer.alloc 4
    err.type = Ref.types.int32
    str = Buffer.alloc UplinkConfig.size
    str.type = Ref.types.CString

    @handle = storj.new_uplink uplinkConfig.ref(), str, err


module.exports = Uplink
