import '../dto/reponse_codes_dto.dart';

void handleResponseCodes(ResponseCodesDto dto) {
  if (dto.result != ApiResponseCodes.ok) {
    throw dto.result.toString();
  }
}
