import shutil
import sys
import os


def vmsg_load(path: str) -> dict[str, str]:
    ret: dict[str, str] = {}
    if not os.path.isfile(path):
        raise FileNotFoundError("文件不存在")
    with open(path, "r", encoding="utf-8") as fp:
        for line in fp.readlines():
            if "=" not in line:
                continue
            key, _, value = line.partition("=")
            key = key.rstrip()
            value = value.lstrip()
            ret[key] = value
    return ret


def vmsg_save(data: dict[str, str], path: str) -> None:
    with open(path, "w", encoding="utf-8") as fp:
        for key, value in data.items():
            fp.write(f"{key} = {value}")


if __name__ == "__main__":
    os.chdir(os.path.dirname(__file__))

    if not all(
        os.path.isfile(path) for path in ("base/vmware.vmsg", "new/vmware.vmsg")
    ):
        print("请确保`base`与`new`文件夹下都放有vmware.vmsg")
    if os.path.exists("out"):
        shutil.rmtree("out")
    os.mkdir("out")
    data_base = vmsg_load("base/vmware.vmsg")
    data_new = vmsg_load("new/vmware.vmsg")
    data_replace = vmsg_load("replace/vmware.vmsg")
    data_base |= data_replace
    len_base = len(data_base)
    len_new = len(data_new)
    print(
        f"本地化键数(简体中文(修补后) | 其它语言本地化文件): {len_base} | {len_new}\n{'数目一致' if len_base == len_new else f'数目不同(相差{len_new-len_base}条)' if len_base < len_new else f"数目不同(多出{len_base-len_new}条)(可能由于部分本地化键弃用)"}"
    )
    differ_count = 0
    for key, value in data_new.items():
        if key in data_base:
            continue
        else:
            differ_count += 1
            print(f"{key} = {value}", end="")
    if differ_count and "-force" not in sys.argv:
        print("简体中文本地化不全")
        if "y" not in input("是否继续生成\n[y/N]>").lower():
            exit()
    if len_base > len_new:
        print("清理多余本地化键...")
        data_base = {
            key: value
            for key, value in data_base.items()
            if None == print("" if key in data_new else f"{key} = {value}", end="")
            and key in data_new
        }
        print("清理完成!")
    print("开始生成补丁...")
    os.mkdir("out/zh_CN")
    vmsg_save(data_base, "out/zh_CN/vmware.vmsg")
    print("将新的vmware.vmsg生成至: 'out/vmware.vmsg'")
    shutil.copytree("replace/initool", "out/initool")
    print("将initool复制至: `out/initool`")
    shutil.copyfile("replace/安装汉化.bat", "out/安装汉化.bat")
    print("将安装脚本复制至: `out/安装汉化.bat`")
    # TODO: 还未汉化dll,先用旧版的,记得将`base`改成`replace`
    # TODO: 复制时计算哈希值,保存至批处理方便安装时校验文件
    shutil.copyfile("base/vmappsdk-zh_CN.dll", "out/zh_CN/vmappsdk-zh_CN.dll")
    shutil.copyfile("base/vmui-zh_CN.dll", "out/zh_CN/vmui-zh_CN.dll")
    print(
        "将dll文件复制至: `out/zh_CN/vmappsdk-zh_CN.dll` 与 `out/zh_CN/vmui-zh_CN.dll`"
    )
