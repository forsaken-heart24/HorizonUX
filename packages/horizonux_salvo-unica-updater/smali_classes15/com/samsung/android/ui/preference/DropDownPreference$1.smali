.class Lcom/samsung/android/ui/preference/DropDownPreference$1;
.super Ljava/lang/Object;
.source "DropDownPreference.java"

# interfaces
.implements Landroid/widget/AdapterView$OnItemSelectedListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/samsung/android/ui/preference/DropDownPreference;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/samsung/android/ui/preference/DropDownPreference;


# direct methods
.method constructor <init>(Lcom/samsung/android/ui/preference/DropDownPreference;)V
    .locals 0
    .param p1, "this$0"    # Lcom/samsung/android/ui/preference/DropDownPreference;

    .line 100
    iput-object p1, p0, Lcom/samsung/android/ui/preference/DropDownPreference$1;->this$0:Lcom/samsung/android/ui/preference/DropDownPreference;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onItemSelected(Landroid/widget/AdapterView;Landroid/view/View;IJ)V
    .locals 2
    .param p2, "v"    # Landroid/view/View;
    .param p3, "position"    # I
    .param p4, "id"    # J
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;",
            "Landroid/view/View;",
            "IJ)V"
        }
    .end annotation

    .line 103
    .local p1, "parent":Landroid/widget/AdapterView;, "Landroid/widget/AdapterView<*>;"
    if-ltz p3, :cond_0

    .line 104
    iget-object v0, p0, Lcom/samsung/android/ui/preference/DropDownPreference$1;->this$0:Lcom/samsung/android/ui/preference/DropDownPreference;

    invoke-virtual {v0}, Lcom/samsung/android/ui/preference/DropDownPreference;->getEntryValues()[Ljava/lang/CharSequence;

    move-result-object v0

    aget-object v0, v0, p3

    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 105
    .local v0, "value":Ljava/lang/String;
    iget-object v1, p0, Lcom/samsung/android/ui/preference/DropDownPreference$1;->this$0:Lcom/samsung/android/ui/preference/DropDownPreference;

    invoke-virtual {v1}, Lcom/samsung/android/ui/preference/DropDownPreference;->getValue()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_0

    iget-object v1, p0, Lcom/samsung/android/ui/preference/DropDownPreference$1;->this$0:Lcom/samsung/android/ui/preference/DropDownPreference;

    invoke-virtual {v1, v0}, Lcom/samsung/android/ui/preference/DropDownPreference;->callChangeListener(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 106
    iget-object v1, p0, Lcom/samsung/android/ui/preference/DropDownPreference$1;->this$0:Lcom/samsung/android/ui/preference/DropDownPreference;

    invoke-virtual {v1, v0}, Lcom/samsung/android/ui/preference/DropDownPreference;->setValue(Ljava/lang/String;)V

    .line 109
    .end local v0    # "value":Ljava/lang/String;
    :cond_0
    return-void
.end method

.method public onNothingSelected(Landroid/widget/AdapterView;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/widget/AdapterView<",
            "*>;)V"
        }
    .end annotation

    .line 112
    .local p1, "parent":Landroid/widget/AdapterView;, "Landroid/widget/AdapterView<*>;"
    return-void
.end method
