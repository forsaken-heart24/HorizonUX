.class Lcom/samsung/android/ui/preference/SeslListPreference$SavedState$1;
.super Ljava/lang/Object;
.source "SeslListPreference.java"

# interfaces
.implements Landroid/os/Parcelable$Creator;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Landroid/os/Parcelable$Creator<",
        "Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 0

    .line 167
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;
    .locals 1
    .param p1, "in"    # Landroid/os/Parcel;

    .line 170
    new-instance v0, Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;

    invoke-direct {v0, p1}, Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;-><init>(Landroid/os/Parcel;)V

    return-object v0
.end method

.method public bridge synthetic createFromParcel(Landroid/os/Parcel;)Ljava/lang/Object;
    .locals 0

    .line 167
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/SeslListPreference$SavedState$1;->createFromParcel(Landroid/os/Parcel;)Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;

    move-result-object p1

    return-object p1
.end method

.method public newArray(I)[Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;
    .locals 1
    .param p1, "size"    # I

    .line 175
    new-array v0, p1, [Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;

    return-object v0
.end method

.method public bridge synthetic newArray(I)[Ljava/lang/Object;
    .locals 0

    .line 167
    invoke-virtual {p0, p1}, Lcom/samsung/android/ui/preference/SeslListPreference$SavedState$1;->newArray(I)[Lcom/samsung/android/ui/preference/SeslListPreference$SavedState;

    move-result-object p1

    return-object p1
.end method
