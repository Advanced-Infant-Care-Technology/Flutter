import 'dart:developer';
import 'package:care_nest/core/helpers/constants.dart';
import 'package:care_nest/core/helpers/shared_pref_helper.dart';
import 'package:care_nest/features/reminders/medications/data/models/get_all_medication_schedule/get_all_medication_schedule_response.dart';
import 'package:care_nest/features/reminders/medications/data/models/update_medication_schedule/update_medication_schedule_request.dart';
import 'package:care_nest/features/reminders/medications/data/repos/update_medication_schedule_repo.dart';
import 'package:care_nest/features/reminders/medications/logic/update_medication_schedule_cubit/update_medication_schedule_state.dart';
import 'package:care_nest/features/reminders/medications/ui/widgets/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateMedicationScheduleCubit
    extends Cubit<UpdateMedicationScheduleState> {
  UpdateMedicationScheduleCubit(this._repository, this.medicinesData)
      : super(const UpdateMedicationScheduleState.initial());

  final UpdateMedicationScheduleRepo _repository;
  final MedicationData medicinesData;
  TextEditingController medicationNameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController beginController = TextEditingController();
  TextEditingController endController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Convert and bind time with timeController
  TimeOfDay? _time;
  TimeOfDay? get time => _time;
  set time(TimeOfDay? newTime) {
    _time = newTime;
    timeController.text = newTime != null
        ? "${newTime.hour}:${newTime.minute}" // تنسيق بسيط للوقت
        : '';
  }

  // Convert and bind begin date with beginController
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? newStartDate) {
    _startDate = newStartDate;
    beginController.text =
        newStartDate != null ? "${newStartDate.toLocal()}".split(' ')[0] : '';
  }

  // Convert and bind end date with endController
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? newEndDate) {
    _endDate = newEndDate;
    endController.text =
        newEndDate != null ? "${newEndDate.toLocal()}".split(' ')[0] : '';
  }

  void validateAndUpdateFields() {
    try {
      // التحقق من الحقول النصية وتحديث القيم
      if (timeController.text.isNotEmpty) {
        final timeParts = timeController.text.split(':');
        _time = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }

      if (beginController.text.isNotEmpty) {
        _startDate = DateTime.parse(beginController.text);
      }

      if (endController.text.isNotEmpty) {
        _endDate = DateTime.parse(endController.text);
      }
    } catch (e) {
      log("Error in parsing fields: $e");
    }
  }

  void emitUpdateMedicationScheduleState(
      String babyId, String scheduleId) async {
    log('Starting update operation for schedule: $scheduleId of baby: $babyId');

    emit(const UpdateMedicationScheduleState.updateMedicationLoading());

    validateAndUpdateFields();

    if (_time == null || _startDate == null || _endDate == null) {
      log("Missing time or date fields");

      return;
    }

    String token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    log('Authorization Token Retrieved: $token');

    final request = UpdateMedicationScheduleRequest(
      medicationName: medicationNameController.text.isNotEmpty
          ? medicationNameController.text
          : medicinesData.medicationName,
      time: timeController.text.isNotEmpty
          ? timeController.text
          : medicinesData.time.toString(),
      begin: beginController.text.isNotEmpty
          ? beginController.text
          : medicinesData.begin.toString(),
      end: endController.text.isNotEmpty
          ? endController.text
          : medicinesData.end.toString(),
    );

    final response = await _repository.updateMedicationSchedule(
      babyId: babyId,
      scheduleId: scheduleId,
      token: token,
      request: request,
    );

    response.when(
      success: (updateMedicationResponse) {
        log('Update Medication Schedule Success: $updateMedicationResponse');
        emit(UpdateMedicationScheduleState.updateMedicationSuccess(
            updateMedicationResponse));
        updateMedicationNotification();
      },
      failure: (error) {
        String errorMessage = error.signUpErrorModel.errors?.first.msg ??
            'Unknown error occurred';
        log('Error Occurred: $errorMessage');
        emit(UpdateMedicationScheduleState.updateMedicationError(
            error: errorMessage));
      },
    );
  }

  void updateMedicationNotification() async {
    if (_time == null || _startDate == null || _endDate == null) {
      log("Missing time or date fields");
      return;
    }
    final babyId =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.babyId);
    final babyName =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.babyName);
    NotificationService.updateMedicationNotification(
      childId: babyId,
      medicationName: medicationNameController.text,
      time: _time!,
      startDate: _startDate!,
      endDate: _endDate!,
      childName: babyName,
    );
  }
}
