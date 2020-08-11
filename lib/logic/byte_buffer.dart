import 'dart:math';
import 'dart:convert';
import 'package:typed_data/typed_buffers.dart';

// 二进制得读写缓存
class ByteBuffer {
  // 读/写得指针位置
  int position = 0;
  // 实际得缓存
  Uint8Buffer buffer;

  int get remain => length - position;
  int get length => buffer.length;
  bool get withData => remain > 0;
  set advance(int k) => position = min(max(position + k, 0), length);
  set descend(int k) => position = min(max(position - k, 0), length);
  set seek(int k) => position = min(max(k, 0), length);
  void reset() {
    position = 0;
  }

  ByteBuffer(this.buffer);
  ByteBuffer.fromList(List<int> data) {
    buffer = new Uint8Buffer();
    buffer.addAll(data);
  }

  void addAll(List<int> data) {
    buffer.addAll(data);
  }

  void shrink() {
    buffer.removeRange(0, position);
    position = 0;
  }

  // 缓存数据得读取
  int readByte() {
    final int tmp = buffer[position];
    if (position < length) {
      position++;
    } else {
      return -1;
    }
    return tmp;
  }

  int readShort() {
    // 网络字节顺序（大尾顺序）（即一个数的高位字节存放于低地址单元，低位字节存放在高地址单元中）
    final int high = readByte();
    final int low = readByte();
    return (high << 8) + low;
  }

  Uint8Buffer read(int count) {
    if (length < count || (position + count) > length) {
      print("Uint8Buffer read(int count)失败了,请求:$count,但实际只有$length!");
      return Uint8Buffer();
    }
    final Uint8Buffer tmp = Uint8Buffer();
    tmp.addAll(buffer.getRange(position, position + count));
    position += count;
    final Uint8Buffer tmp2 = Uint8Buffer();
    tmp2.addAll(tmp);
    return tmp2;
  }

  // 缓存数据得写入
  void writeByte(int byte) {
    if (buffer.length == position) {
      buffer.add(byte);
    } else {
      buffer[position] = byte;
    }
    position++;
  }

  void writeShort(int short) {
    writeByte(short >> 8);
    writeByte(short & 0xFF);
  }

  void write(Uint8Buffer buffer) {
    if (this.buffer == null) {
      this.buffer = buffer;
    } else {
      this.buffer.addAll(buffer);
    }
    position = length;
  }

  void writeString(String s) {
    final Uint8Buffer stringBytes = Uint8Buffer();
    var tmp = utf8.encode(s);
    stringBytes.add(tmp.length >> 8);
    stringBytes.add(tmp.length & 0xFF);
    stringBytes.addAll(tmp);
    this.write(stringBytes);
  }

  String readString() {
    final Uint8Buffer lengthBytes = read(2);
    final int stringLength = (lengthBytes[0] << 8) + lengthBytes[1];
    final Uint8Buffer stringBuff = read(stringLength);
    return utf8.decode(stringBuff.toList());
  }
}
