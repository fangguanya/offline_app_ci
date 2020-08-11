// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import "dart:core";
import 'package:operator_controller/models/core/vnum.dart' as prefix0;
import 'package:operator_controller/models/device/types.dart' as prefix1;

// ignore:unused_import
import "package:reflectable/mirrors.dart" as m;
// ignore:unused_import
import "package:reflectable/src/reflectable_builder_based.dart" as r;
// ignore:unused_import
import "package:reflectable/reflectable.dart" as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.VnumTypeReflectable(): new r.ReflectorData(
      <m.TypeMirror>[
        new r.NonGenericClassMirrorImpl(
            r"DeviceType",
            r".DeviceType",
            7,
            0,
            const prefix0.VnumTypeReflectable(),
            const <int>[0, 1, 2, 3, 4, 5, 6, 7, 8, 24, 34, 35, 36],
            const <int>[37, 38, 39, 40, 41, 24, 42],
            const <int>[25, 26, 27, 28, 29, 30, 31, 32, 33],
            -1,
            {
              r"SWITCH": () => prefix1.DeviceType.SWITCH,
              r"ELEVATOR": () => prefix1.DeviceType.ELEVATOR,
              r"ROTATOR": () => prefix1.DeviceType.ROTATOR,
              r"JOYSTICK": () => prefix1.DeviceType.JOYSTICK,
              r"AUDIO": () => prefix1.DeviceType.AUDIO,
              r"GSERVER": () => prefix1.DeviceType.GSERVER,
              r"HSERVER": () => prefix1.DeviceType.HSERVER,
              r"TSERVER": () => prefix1.DeviceType.TSERVER,
              r"MONITOR": () => prefix1.DeviceType.MONITOR
            },
            {},
            {
              r"define": (b) => (fromValue) =>
                  b ? new prefix1.DeviceType.define(fromValue) : null,
              r"": (b) => (value) => b ? new prefix1.DeviceType(value) : null,
              r"fromJson": (b) =>
                  (json) => b ? new prefix1.DeviceType.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.NonGenericClassMirrorImpl(
            r"DeviceStateType",
            r".DeviceStateType",
            7,
            1,
            const prefix0.VnumTypeReflectable(),
            const <int>[10, 11, 12, 43, 47, 48, 49],
            const <int>[37, 38, 39, 40, 41, 43, 42],
            const <int>[44, 45, 46],
            -1,
            {
              r"ONOFF": () => prefix1.DeviceStateType.ONOFF,
              r"BATTERY": () => prefix1.DeviceStateType.BATTERY,
              r"SWITCHS": () => prefix1.DeviceStateType.SWITCHS
            },
            {},
            {
              r"define": (b) => (fromValue) =>
                  b ? new prefix1.DeviceStateType.define(fromValue) : null,
              r"": (b) =>
                  (value) => b ? new prefix1.DeviceStateType(value) : null,
              r"fromJson": (b) => (json) =>
                  b ? new prefix1.DeviceStateType.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.NonGenericClassMirrorImpl(
            r"DeviceStateValue",
            r".DeviceStateValue",
            7,
            2,
            const prefix0.VnumTypeReflectable(),
            const <int>[13, 14, 15, 16, 50, 55, 56, 57],
            const <int>[37, 38, 39, 40, 41, 50, 42],
            const <int>[51, 52, 53, 54],
            -1,
            {
              r"IDLE": () => prefix1.DeviceStateValue.IDLE,
              r"OFF": () => prefix1.DeviceStateValue.OFF,
              r"RUN": () => prefix1.DeviceStateValue.RUN,
              r"CONN": () => prefix1.DeviceStateValue.CONN
            },
            {},
            {
              r"define": (b) => (fromValue) =>
                  b ? new prefix1.DeviceStateValue.define(fromValue) : null,
              r"": (b) =>
                  (value) => b ? new prefix1.DeviceStateValue(value) : null,
              r"fromJson": (b) => (json) =>
                  b ? new prefix1.DeviceStateValue.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.NonGenericClassMirrorImpl(
            r"HtcDeviceType",
            r".HtcDeviceType",
            7,
            3,
            const prefix0.VnumTypeReflectable(),
            const <int>[17, 18, 19, 20, 58, 63, 64, 65],
            const <int>[37, 38, 39, 40, 41, 58, 42],
            const <int>[59, 60, 61, 62],
            -1,
            {
              r"HMD": () => prefix1.HtcDeviceType.HMD,
              r"CONTROLLER": () => prefix1.HtcDeviceType.CONTROLLER,
              r"TRACKER": () => prefix1.HtcDeviceType.TRACKER,
              r"BASE": () => prefix1.HtcDeviceType.BASE
            },
            {},
            {
              r"define": (b) => (fromValue) =>
                  b ? new prefix1.HtcDeviceType.define(fromValue) : null,
              r"": (b) =>
                  (value) => b ? new prefix1.HtcDeviceType(value) : null,
              r"fromJson": (b) =>
                  (json) => b ? new prefix1.HtcDeviceType.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.NonGenericClassMirrorImpl(
            r"ExecutionType",
            r".ExecutionType",
            7,
            4,
            const prefix0.VnumTypeReflectable(),
            const <int>[21, 22, 23, 66, 70, 71, 72],
            const <int>[37, 38, 39, 40, 41, 66, 42],
            const <int>[67, 68, 69],
            -1,
            {
              r"START": () => prefix1.ExecutionType.START,
              r"STOP": () => prefix1.ExecutionType.STOP,
              r"RESTART": () => prefix1.ExecutionType.RESTART
            },
            {},
            {
              r"define": (b) => (fromValue) =>
                  b ? new prefix1.ExecutionType.define(fromValue) : null,
              r"": (b) =>
                  (value) => b ? new prefix1.ExecutionType(value) : null,
              r"fromJson": (b) =>
                  (json) => b ? new prefix1.ExecutionType.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.GenericClassMirrorImpl(
            r"Vnum",
            r".Vnum",
            519,
            5,
            const prefix0.VnumTypeReflectable(),
            const <int>[9, 73, 74, 37, 40, 75, 76, 77, 78],
            const <int>[37, 38, 39, 40, 41, 74, 42],
            const <int>[73],
            -1,
            {r"allCasesFor": () => prefix0.Vnum.allCasesFor},
            {},
            {
              r"fromValue": (b) => (value, baseType) =>
                  b ? new prefix0.Vnum.fromValue(value, baseType) : null,
              r"fromJson": (b) =>
                  (json) => b ? new prefix0.Vnum.fromJson(json) : null
            },
            -1,
            -1,
            const <int>[-1],
            null,
            null,
            (o) => false,
            const <int>[6],
            5),
        new r.TypeVariableMirrorImpl(
            r"T", r".Vnum.T", const prefix0.VnumTypeReflectable(), -1, 5, null)
      ],
      <m.DeclarationMirror>[
        new r.VariableMirrorImpl(r"SWITCH", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"ELEVATOR", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"ROTATOR", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"JOYSTICK", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"AUDIO", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"GSERVER", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"HSERVER", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"TSERVER", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"MONITOR", 33941, 0,
            const prefix0.VnumTypeReflectable(), 0, 0, 0, null, null),
        new r.VariableMirrorImpl(r"value", 1029, 5,
            const prefix0.VnumTypeReflectable(), -1, -1, -1, null, null),
        new r.VariableMirrorImpl(r"ONOFF", 33941, 1,
            const prefix0.VnumTypeReflectable(), 1, 1, 1, null, null),
        new r.VariableMirrorImpl(r"BATTERY", 33941, 1,
            const prefix0.VnumTypeReflectable(), 1, 1, 1, null, null),
        new r.VariableMirrorImpl(r"SWITCHS", 33941, 1,
            const prefix0.VnumTypeReflectable(), 1, 1, 1, null, null),
        new r.VariableMirrorImpl(r"IDLE", 33941, 2,
            const prefix0.VnumTypeReflectable(), 2, 2, 2, null, null),
        new r.VariableMirrorImpl(r"OFF", 33941, 2,
            const prefix0.VnumTypeReflectable(), 2, 2, 2, null, null),
        new r.VariableMirrorImpl(r"RUN", 33941, 2,
            const prefix0.VnumTypeReflectable(), 2, 2, 2, null, null),
        new r.VariableMirrorImpl(r"CONN", 33941, 2,
            const prefix0.VnumTypeReflectable(), 2, 2, 2, null, null),
        new r.VariableMirrorImpl(r"HMD", 33941, 3,
            const prefix0.VnumTypeReflectable(), 3, 3, 3, null, null),
        new r.VariableMirrorImpl(r"CONTROLLER", 33941, 3,
            const prefix0.VnumTypeReflectable(), 3, 3, 3, null, null),
        new r.VariableMirrorImpl(r"TRACKER", 33941, 3,
            const prefix0.VnumTypeReflectable(), 3, 3, 3, null, null),
        new r.VariableMirrorImpl(r"BASE", 33941, 3,
            const prefix0.VnumTypeReflectable(), 3, 3, 3, null, null),
        new r.VariableMirrorImpl(r"START", 33941, 4,
            const prefix0.VnumTypeReflectable(), 4, 4, 4, null, null),
        new r.VariableMirrorImpl(r"STOP", 33941, 4,
            const prefix0.VnumTypeReflectable(), 4, 4, 4, null, null),
        new r.VariableMirrorImpl(r"RESTART", 33941, 4,
            const prefix0.VnumTypeReflectable(), 4, 4, 4, null, null),
        new r.MethodMirrorImpl(r"toJson", 65538, 0, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 0, 0, 0, 25),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 1, 0, 0, 26),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 2, 0, 0, 27),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 3, 0, 0, 28),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 4, 0, 0, 29),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 5, 0, 0, 30),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 6, 0, 0, 31),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 7, 0, 0, 32),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 8, 0, 0, 33),
        new r.MethodMirrorImpl(r"define", 128, 0, -1, 0, 0, null,
            const <int>[0], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 1, 0, -1, 0, 0, null, const <int>[1],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 0, -1, 0, 0, null,
            const <int>[2], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"==", 131074, 5, -1, 6, 6, null, const <int>[3],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"toString", 131074, null, -1, 7, 7, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"noSuchMethod", 65538, null, null, null, null,
            null, const <int>[4], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"hashCode", 131075, 5, -1, 8, 8, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"runtimeType", 131075, null, -1, 9, 9, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 9, -1, -1, 42),
        new r.MethodMirrorImpl(r"toJson", 65538, 1, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 10, 1, 1, 44),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 11, 1, 1, 45),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 12, 1, 1, 46),
        new r.MethodMirrorImpl(r"define", 128, 1, -1, 1, 1, null,
            const <int>[5], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 1, 1, -1, 1, 1, null, const <int>[6],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 1, -1, 1, 1, null,
            const <int>[7], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"toJson", 65538, 2, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 13, 2, 2, 51),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 14, 2, 2, 52),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 15, 2, 2, 53),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 16, 2, 2, 54),
        new r.MethodMirrorImpl(r"define", 128, 2, -1, 2, 2, null,
            const <int>[8], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 1, 2, -1, 2, 2, null, const <int>[9],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 2, -1, 2, 2, null,
            const <int>[10], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"toJson", 65538, 3, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 17, 3, 3, 59),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 18, 3, 3, 60),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 19, 3, 3, 61),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 20, 3, 3, 62),
        new r.MethodMirrorImpl(r"define", 128, 3, -1, 3, 3, null,
            const <int>[11], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 1, 3, -1, 3, 3, null, const <int>[12],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 3, -1, 3, 3, null,
            const <int>[13], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"toJson", 65538, 4, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 21, 4, 4, 67),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 22, 4, 4, 68),
        new r.ImplicitGetterMirrorImpl(
            const prefix0.VnumTypeReflectable(), 23, 4, 4, 69),
        new r.MethodMirrorImpl(r"define", 128, 4, -1, 4, 4, null,
            const <int>[14], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 1, 4, -1, 4, 4, null, const <int>[15],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 4, -1, 4, 4, null,
            const <int>[16], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"allCasesFor", 4325394, 5, -1, 10, 11, null,
            const <int>[17], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"toJson", 65538, 5, null, null, null, null,
            const <int>[], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"", 128, 5, -1, 12, 5, null, const <int>[],
            const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"define", 128, 5, -1, 12, 5, null,
            const <int>[18], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromValue", 1, 5, -1, 12, 5, null,
            const <int>[19, 20], const prefix0.VnumTypeReflectable(), null),
        new r.MethodMirrorImpl(r"fromJson", 1, 5, -1, 12, 5, null,
            const <int>[21], const prefix0.VnumTypeReflectable(), null)
      ],
      <m.ParameterMirror>[
        new r.ParameterMirrorImpl(
            r"fromValue",
            32774,
            34,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            32774,
            35,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            36,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"o",
            16390,
            37,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"invocation",
            32774,
            39,
            const prefix0.VnumTypeReflectable(),
            -1,
            13,
            13,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"fromValue",
            32774,
            47,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            32774,
            48,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            49,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"fromValue",
            32774,
            55,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            32774,
            56,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            57,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"fromValue",
            32774,
            63,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            32774,
            64,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            65,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"fromValue",
            32774,
            70,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            32774,
            71,
            const prefix0.VnumTypeReflectable(),
            -1,
            8,
            8,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            72,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"object",
            16390,
            73,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            6,
            76,
            const prefix0.VnumTypeReflectable(),
            null,
            -1,
            -1,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"value",
            6,
            77,
            const prefix0.VnumTypeReflectable(),
            null,
            -1,
            -1,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"baseType",
            16390,
            77,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null),
        new r.ParameterMirrorImpl(
            r"json",
            16390,
            78,
            const prefix0.VnumTypeReflectable(),
            null,
            null,
            null,
            null,
            null,
            null,
            null)
      ],
      <Type>[
        prefix1.DeviceType,
        prefix1.DeviceStateType,
        prefix1.DeviceStateValue,
        prefix1.HtcDeviceType,
        prefix1.ExecutionType,
        prefix0.Vnum,
        bool,
        String,
        int,
        Type,
        const m.TypeValue<List<prefix0.Vnum<dynamic>>>().type,
        List,
        const r.FakeType(r".Vnum<T>"),
        Invocation
      ],
      6,
      {
        r"==": (dynamic instance) => (x) => instance == x,
        r"toString": (dynamic instance) => instance.toString,
        r"noSuchMethod": (dynamic instance) => instance.noSuchMethod,
        r"hashCode": (dynamic instance) => instance.hashCode,
        r"runtimeType": (dynamic instance) => instance.runtimeType,
        r"toJson": (dynamic instance) => instance.toJson,
        r"value": (dynamic instance) => instance.value
      },
      {},
      null,
      [])
};

final _memberSymbolMap = null;

initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
