

class InitializeSupabaseModel {
    final String? supabaseUrl;
    final String? apiKey;

    InitializeSupabaseModel({
        this.supabaseUrl,
        this.apiKey,
    });

    factory InitializeSupabaseModel.fromJson(Map<String, dynamic> json) => InitializeSupabaseModel(
        supabaseUrl: json["supabaseUrl"],
        apiKey: json["apiKey"],
    );

    Map<String, dynamic> toJson() => {
        "supabaseUrl": supabaseUrl,
        "apiKey": apiKey,
    };
}
