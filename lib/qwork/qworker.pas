unit qworker;
{$I 'qdac.inc'}

interface

// �ú�����Ƿ�����QMapSymbols��Ԫ����ȡ�������ƣ��������ȡ�������������ƣ���ֻ���ǵ�ַ
{$IFDEF MSWINDOWS}
{$DEFINE USE_MAP_SYMBOLS}
{$ENDIF}
// ���߳���̫��ʱTQSimpleLock��������������Ŀ��������������ٽ磬������ʱ����ʹ��
{ .$DEFINE QWORKER_SIMPLE_LOCK }
{
  ��Դ������QDAC��Ŀ����Ȩ��swish(QQ:109867294)���С�
  (1)��ʹ�����ɼ�����
  ���������ɸ��ơ��ַ����޸ı�Դ�룬�������޸�Ӧ�÷��������ߣ������������ڱ�Ҫʱ��
  �ϲ�������Ŀ���Թ�ʹ�ã��ϲ����Դ��ͬ����ѭQDAC��Ȩ�������ơ�
  ���Ĳ�Ʒ�Ĺ����У�Ӧ�������µİ汾����:
  ����Ʒʹ�õ�JSON����������QDAC��Ŀ�е�QJSON����Ȩ���������С�
  (2)������֧��
  �м������⣬�����Լ���QDAC�ٷ�QQȺ250530692��ͬ̽�֡�
  (3)������
  ����������ʹ�ñ�Դ�������Ҫ֧���κη��á���������ñ�Դ������а�������������
  ������Ŀ����ǿ�ƣ�����ʹ���߲�Ϊ�������ȣ��и���ľ���Ϊ�����ָ��õ���Ʒ��
  ������ʽ��
  ֧������ guansonghuan@sina.com �����������
  �������У�
  �����������
  �˺ţ�4367 4209 4324 0179 731
  �����У��������г����ŷ索����
}

{ �޶���־
  2016.2.23
  ==========
  * ������ WaitJob ���ض������£������ҵ���ᱻ�����߼�ʱ���õ����⣨�ɺƱ��棩
  2016.1.23
  ==========
  * �� MsgWaitForEvent ��������
  2016.1.8
  ==========
  * ������ WaitJob ѭ����ͨ��ҵʱ��δ��ȷ����AJob.Next��һ����ҵ�����⣨С�챨�棩
  2015.11.20
  ==========
  + ���� WaitJob ���ȴ�һ����ͨ��ҵ��ʱ����ɣ���ľ���飩
  * �޸��� TQJob �Ľṹ������ Source Ӱ���ظ���ҵ�� Interval �� FirstDelay �������󶡱��棩
  2015.11.6
  =========
  * �������������� ClearJobState �����⣬��ɰ���������ҵ��������ʱ���˳�ʱ�ڴ�й¶�����⣨��ľ���棩
  2015.8.27
  =========
  * ������ TQJobGroup.Add ����������֧�ְ汾������

  2015.8.11
  =========
  * �����˼ƻ�������ҵ��ʱʧЧʱ���������㷨����
  * �ƻ�������ҵ��֧�ָ����ӵı���ʽ��������ߵ��루��ľ�ṩ������ϣ�
  2015.7.27
  =========
  * ������ SetMaxWorkers ʱ��ʱ����ҵ����û�и��ű��������

  2015.7.3
  =========
  * �������ܴμ��㺯����������ܴμ��������Ч�����⣨�ഺ���棩
  2015.6.16
  ==========
  * ������TQJobGroup.Cancelʱ����Ͷ�ĵ���ҵû����ȷȡ�������⣨�˼����棩
  * �޸�TQJobGroup.Cancelȡ����ҵʱ��WaitFor�Ľ��ΪwrAbandoned�����û�б�ȡ�������������أ�
  2015.6.15
  =========
  * �ƻ���ҵ��������ظ���ҵĬ�ϲ��ٳ�ʼ�ʹ�����ֻ�з���ƻ������Żᴴ��
  * �ƻ���ҵ���ʱ����޸ĳɰ����Ӷ��루������ÿ���ӵ�0��0���봥����
  2015.5.13
  =========
  * ������ LookupIdleWorker ����Ͷ����������ʱ������δ��������Worker�����������⣨LakeView���棩
  2015.4.19
  =========
  * �������ϴ��޸Ľ���㷨���ÿ��һ��ʱ��CPUռ���ʻ����������⣨�ֺ뱨�棩

  2015.4.7
  =========
  + TQJobExtData ����һ���������չ���Է��㴫�ݶ������
  2015.4.6
  =========
  + TQJob ���� Handle ���ԣ��������Լ���Ӧ�ľ��ʵ����ַ���ֺ롢����С�׽��飩
  * ClearSingleJob ��������ʱ�Ƿ�ȴ�����ִ�й�����ɵĴ���
  * EnumJobState ����Լƻ���ҵ��ִ��
  * �޸ľ����־���壬0,1,2,3�ֱ��Ӧ����ҵ���ظ���ҵ���ź���ҵ�ͼƻ���ҵ

  2015.4.2
  =========
  * ������ GetTimeTick ���������ɶ�ʱ��ҵ����ʧ�ܵ����⣨���±��棩
  + ���� Plan ����֧�ּƻ��������͵���ҵ�������СΪ1���ӣ�

  2015.3.9
  =========
  * ������ TQRepeatJobs.DoTimeCompare �Ƚ�ʱ��ʱ�������������ض�Ӧ�û����³��������⣨�����������棩
  2015.2.26
  =========
  * ���������������� 2007 ���޷���������⣨My Spring ���棩
  * ���������������� Android / iOS / OSX ���޷���������⣨�����ٷʱ��棩
  2015.2.24
  =========
  + TQJobGroup ���� Insert �������ڲ�����ҵ���ض�λ�ã�â���������
  2015.2.9
  =========
  * �������ƶ�ƽ̨����ҵ����Ϊ��������������£��ظ��ͷ���������ָ�������
  2015.2.3
  =========
  * ��������ʹ�� FastMM4 ������ FullDebugInIDE ģʽʱ���˳�ʱ���������⣨ԡ���������棬�ഺȷ�ϣ�
  * ������ OnError �������Ƿ���������

  2015.1.29
  =========
  * ������ TQSimpleJobs.Clear �����һ����������Ҫʱ�㷨�߼����������⣨KEN���棩
  * ���������ض��龳���޷���ʱ�����ظ���ҵ������

  2015.1.28
  =========
  * ������ Post / At �ظ���ҵʱ������ظ���� AInterval ����ֵС�� 0 ʱ���������ظ�������

  2015.1.26
  =========
  * ������ TQJobGroup.Cancel ȡ����ҵʱ������ɵȴ�ֱ����ʱ�����⣨�����ٷʱ��棩
  2015.1.15
  =========
  + TQJobGroup ����ȫ�ֺ���������������֧��

  2015.1.12
  =========
  + �������� PeekJobState ����ȡ������ҵ��״̬��Ϣ
  + �������� EnumJobStates ����ȡ������ҵ��״̬��Ϣ

  2015.1.9
  =========
  * �������� 2007�ļ�������,Clear(PIntPtr,ACount)��Ϊ��ClearJobs

  2014.12.25
  ==========
  * QWorker��Clear(AHandle:IntPtr)������Ϊ��ClearSingleJob���Խ��������Delphi�б������⣨���壩

  2014.12.24
  ==========
  + TQWorkers.Clear�����µ����أ�����һ�������������ҵ����������У������ʹ�ã�lionet����)

  2014.12.3
  ==========
  * TQJobGroup.Cancel�����Ƿ�ȴ��������е���ҵ�����������Ա�������ҵ��ֱ��ȡ��
  ����������ȫ����ҵʱ��ѭ�������⣨�ֺ룩

  2014.11.25
  ==========
  * ������WaitSignal���������ض�����£������ӳ���ҵʱδ����ȷ����������

  2014.11.24
  ==========
  * �������ƶ�ƽ̨�£�ADataΪ����ʱ������ϵͳ�Զ��������ü�������ɶ�����Զ��ͷŵ����⣨�ֺ뱨�棩
  2014.11.13
  ==========
  + TQJobGroup����FreeAfterDone���ԣ�������ΪTrueʱ��������ҵ��ɺ��Զ��ͷŶ����������ֺ뽨�飩
  * ������TQJobGroup�˳�ʱ�����ڿ�������������
  * �����˷�����ҵδȫ������˳�ʱ��û���Զ��ͷ�����ڴ�й¶�����⣨�ֺ뱨�棩

  2014.11.11
  ==========
  * �޸���ҵ���ؾ������ΪIntPtr��������Int64����32λƽ̨�����Կ�һЩ������С�ס��ֺ룩

  2014.11.8
  ==========
  * ������LongtimeJob�ڷ���ֵΪ0ʱ����ҵ����Push��������⣨����С�ף�
  * �������ظ���ҵ������չ����ʱ���״�ִ������ҵ��ᱻ�ͷŵ����⣨����С�ף�
  * ������Assignʱ�������������ü���������
  * For������TQWorkersʵ����ʵ��һ�������汾ֱ�ӵ���TQForJobs.For��Ӧ�İ汾
  2014.10.30
  ==========
  * �޸���������ѡ��Լ���2007

  2014.10.28
  ==========
  * ������������ѡ��Լ����ƶ�ƽ̨(�ֺ뱨��)

  2014.10.27
  ===========
  * �޸���ҵͶ�ģ�Post��At��Delay��LongtimeJob�ȣ��ķ���ֵΪInt64���͵ľ��������Ψһ��
  ��һ����ҵ����������Ҫʱ����Clear(���ֵ)�������Ӧ����ҵ����л�ֺ��������
  * TQJobExtDataĬ��ʵ���˸���������͵�֧�֣���л�ֺ��������

  2014.10.26
  ==========
  + ����������ҵ���Զ�����չ�������Ͷ���TQJobExtData�Ա�ָ����ҵ���ͷŹ�������
  jdfFreeAsC1~jdfFreeAsC6�����ƣ���ϸ˵���ο� http://www.qdac.cc/?p=1018 ˵��
  ����л�ֺ��������

  2014.10.21
  ==========
  * Ĭ�����ƶ�ƽ̨��֧��QMapSymbols���ֺ뱨�棩
  * �������ƶ�ƽ̨������TStaticThread���ȼ�ʧ�ܵ����⣨�ֺ뱨��)

  2014.10.16
  ===========
  * ���������ڳ�ʼ��˳���ԭ�����TStaticThread.CheckNeed���������ڳ�������ʱ���������⣨�ഺ����)
  2014.10.14
  ===========
  * ���������ض�������˳�����TStaticThread����Workers.FSimpleJobs��Ч��ַ��ɵ�����(����С���޸�)
  2014.10.11
  ==========
  * ������TQJobGroup��Ͷ����ҵ��Prepare/Runʱ���ظ�Ͷ����ɳ��������⣨����С�ױ��棩
  һ���Ƽ�����˳��ΪPrepare/Add/Run/Wait��
  * ������Forѭ��ʱ��������������

  2014.10.8
  =========
  * ������TQJobGroup.Count������Ч�����⣨�嶾���棩
  * ����������ҵ��ʱ���ӣ���Prepare/Run��ʱδ��ȷִ�е����⣨�嶾���棩
  * ����������TSystemTimes�����ͻ��ɺ����޷���XE3��XE4���޷���������⣨���Ա��棩

  2014.9.29
  =========
  + EnumWorkerStatusʱ�������˹��������һ�δ�����ҵ��ʱ�����
  * ���������ض�����³�ʱ�Զ���͹����߻��Ʋ���Ч�����⣨����С�ױ��棩
  2014.9.26
  =========
  + �����̨��CPU�����ʵļ�飬��CPUռ���ʽϵ�ʱ������Ҫ������������ҵʱ�������¹�����
  + ����EnumWorkerStatus������ö�ٸ�����ҵ��״̬

  2014.9.23
  =========
  * ������δ�ﵽ�������߳����ޣ����Ѵ����Ĺ����߶��ڹ�����ʱ������ɵ��ӳ�����
  2014.9.14
  =========
  + ����Forѭ��������ҵ֧�֣����ʷ�ʽΪTQForJobs.For(...)
  * �޸�TQJobProc/TQJobProcA/TQJobProcG��д�����Ա�������Ķ�
  * ������TQJobGroup.MsgWaitForʱ����Clear����ʱ���Ǵ��ݲ���������

  2014.9.12
  =========
  * �����˶��ͬһʱ��㲢�����ظ���ҵʱ���ܻ����������⣨���������СҶ���棩

  2014.9.10
  =========
  * ������At�������������ʱ���ʱ���㷨����(����С�ױ��沢������

  2014.9.9
  ========
  * �����˹���������IsIdle����첽���Ͷ�ĵĶ����ҵ���ܱ�����ִ�е����⣨����С�ױ��棩
  * ������ͬʱ��������ҵʱ��HasJobRunning����ֻ�жϵ�һ����ҵ�����о��˳����
  ����ʱ����������⣨����С�ױ��棩

  2014.9.1
  =========
  * jdfFreeAsRecord����ΪjdfFreeAsSimpleRecord������ʾ�û����������Զ��ͷŵļ�¼ֻ
  �����ڼ����ͣ�����Ǹ��Ӽ�¼���͵��ͷţ���ʹ��jdfFreeAsC1~jdfFreeAsC6��Ȼ����
  �û��Լ�ȥ��ӦOnCustomFreeData�¼�����(��лqsl�Ͱ�ľ)���ο�Demo�︴�������ͷŵ�
  ���ӡ�
  2014.8.30
  =========
  * �����˹��������ж�ʱ��ҵʱδ����ȷ��ͻָ����������������������⣨����С�ױ��棩

  2014.8.29
  =========
  * ������WaitSignal�ȴ���ʱʱ���������ʹ�����ɵȴ���ʱʱ�䲻�ԵĴ���(����СҶ����)
  2014.8.24
  =========
  * �޸��˵����㷨�����ԭ��FBusyCount���������

  2014.8.22
  =========
  * �Ż����ض��߸��ػ����£�ֱ��Ͷ����ҵ�����ٶȣ���л����С��)
  * ������FMX��Win32/Win64�ļ�������

  2014.8.21
  =========
  * ������TQJobGroupû����ȷ����������ʱ���̵����⣨����С�ױ��棩
  + ��ҵ���ӵ�Data�ͷŷ�ʽ����jdfFreeAsC1~jdfFreeAsC6�Ա��ϲ��Լ�����Data��Ա���ݵ��Զ��ͷ�
  + ����OnCustomFreeData�¼��������ϲ��Լ�����Data��Ա�Ķ����ͷ�����

  2014.8.19
  =========
  * ������TQJob.Synchronize����inline���������2007���޷���ȷ���������
  * ��������Ŀ���ƶ�ƽ̨���������
  2014.8.18
  =========
  * �����˺ϲ��������LongTimeJobͶ���������ƴ��������(־�ı��棩
  * ���������������TQJobGroup.Run������ʱ���ó���������
  + TQJobGroup����MsgWaitFor�������Ա������߳��еȴ������������߳�(�����ٷʲ�����֤)
  + TQJob����Synchronize������ʵ���Ϲ�������TThread.Synchronize����(�����ٷʲ�����֤)

  2014.8.17
  =========
  * �Ľ����ҿ����̻߳��ƣ��Ա��ⲻ��Ҫ��������л����С�׺�Ц���쳾)
  * �ϲ����룬�Լ����ظ�����������л����С�ף�
  * ������Wait�����ӿڣ�AData��AFreeType������ȡ������Ϊ���źŴ���ʱ������ز���
  * TQJobGroup.AfterDone��Ϊ���������ʱ�����жϻ�ʱʱ��Ȼ����
  + TQJobGroup.Add����������AFreeType����
  + TQJobGroup.Run�������볬ʱ���ã�����ָ����ʱ�������δִ����ɣ�����ֹ����ִ��(Bug��û����ע��δ���׸㶨)
  + TQJobGroup.Cancel��������ȡ��δִ�е���ҵִ��

  2014.8.14
  ==========
  * �ο�����С�׵Ľ��飬�޸�Assign������ͬʱTQJobHelper�Ķ�����Ը�Ϊʹ��ͬһ������ʵ��
  * ��������Delphi2007�ϱ��������(����С�ױ��沢�ṩ�޸�)
  2014.8.12
  ==========
  * ������TQJob.Assign�������Ǹ���WorkerProcA��Ա������
  2014.8.8
  ==========
  * �����������߳���Clearʱ����������̵߳���ҵ��Ͷ�ĵ����߳���Ϣ���е���δִ��ʱ
  ���������������(playwo����)

  2014.8.7
  ==========
  * ������TQJobGroup������ҵʱ�������޸���ҵ���״̬������

  2014.8.2
  ==========
  * ��������Windows��DLL��ʹ��QWorkerʱ�������˳�ʱ���߳��쳣��ֹʱ�������޷���
  ��������(С��ɵ����棬�������֤)
  2014.7.29
  ==========
  + ������������ȫ�ֺ���������ʽ����XE5���ϰ汾�У�����֧������������Ϊ��ҵ����
  [ע��]����������Ӧ���ʾֲ�������ֵ
  2014.7.28
  ==========
  * ������ComNeeded�����������ó�ʼ����ɱ�־λ������(����ұ���)
  2014.7.21
  ==========
  * ������Delphi 2007�޷����������

  2014.7.17
  =========
  * ��������FMXƽ̨�ϱ���ʱ����Hint�Ĵ���
  2014.7.14
  =========
  * ������TQJobGroupû�д���AfterDone�¼�������
  * �޸�������Hint�Ĵ���
  2014.7.12
  =========
  + ����TQJobGroup֧����ҵ����
  2014.7.4
  ========
  * ��������FMX�ļ���������(�ֺ뱨��)
  + ����Clear�����ȫ����ҵ������ʵ��(D10����ҽ���)
  * ֧������ҵ������ͨ������IsTerminated��������ȫ������ʱ���ź���ҵ
  2014.7.3
  =========
  + MakeJobProc��֧��ȫ����ҵ��������
  + TQWorkers.Clear�����������������غ�����ʵ������ָ���źŹ�����ȫ����ҵ(�嶾�����顣����)
  * �������ظ���ҵ����ִ��ʱ�޷�����ɾ�������
  2014.6.26
  =========
  * TEvent.WaitFor����������Խ����Delphi2007�ļ�����(D10-����ұ���)
  * ����HPPEMITĬ�����ӱ���Ԫ(�����ٷ� ����)
  2014.6.23
  =========
  * �޸���Windows�����߳�����ҵ�Ĵ�����ʽ���Ը�����COM�ļ����ԣ�D10-����ұ��棩
  2014.6.21
  =========
  * �����˶�COM��֧�֣������Ҫ����ҵ��ʹ��COM���󣬵���Job.Worker.ComNeeded�󼴿�
  �������ʸ���COM����
  2014.6.19
  =========
  * ������DoMainThreadWork�����Ĳ�������˳�����
  * ΪTQWorker������ComNeeded��������֧��COM�ĳ�ʼ����������ҵ��COM��غ�������
  2014.6.17
  =========
  * �źŴ�����ҵʱ�����븽�����ݳ�Ա���������������ӵ�TQJob�ṹ��Data��Ա���Ա�
  �ϲ�Ӧ���ܹ�����Ҫ�ı�ǣ�Ĭ��ֵΪ��
  * ��ҵͶ��ʱ�����˸��ӵĲ�������������ͷŸ��ӵ����ݶ���
}
uses
  classes, types, sysutils, SyncObjs, Variants, dateutils
{$IFDEF UNICODE}, Generics.Collections{$ENDIF}{$IF RTLVersion>=21},
  Rtti{$IFEND >=XE10}
{$IFNDEF MSWINDOWS}
    , fmx.Forms, System.Diagnostics
{$ELSE}
{$IFDEF MSWINDOWS}, Windows, Messages, TlHelp32, Activex{$ENDIF}
{$ENDIF}
{$IFDEF POSIX}, Posix.Base, Posix.Unistd, Posix.Signal, Posix.Pthread,
  Posix.SysTypes{$ENDIF}
    , qstring, qrbtree, qtimetypes {$IFDEF ANDROID}, Androidapi.AppGlue,
  Androidapi.Looper, Androidapi.NativeActivity{$ENDIF};
{$HPPEMIT '#pragma link "qworker"'}

{ *QWorker��һ����̨�����߹����������ڹ����̵߳ĵ��ȼ����С���QWorker�У���С��
  ������λ����Ϊ��ҵ��Job������ҵ���ԣ�
  1����ָ����ʱ����Զ����ƻ�ִ�У������ڼƻ�����ֻ��ʱ�ӵķֱ��ʿ��Ը���
  2���ڵõ���Ӧ���ź�ʱ���Զ�ִ����Ӧ�ļƻ�����
  �����ơ�
  1.ʱ��������ʹ��0.1msΪ������λ����ˣ�64λ�������ֵΪ9223372036224000000��
  ����864000000��Ϳɵý��ԼΪ10675199116�죬��ˣ�QWorker�е���ҵ�ӳٺͶ�ʱ�ظ�
  ������Ϊ10675199116�졣
  2�����ٹ�������Ϊ1�����������ڵ����Ļ��Ƕ���Ļ����ϣ�����������ơ������
  ���õ����ٹ�������������ڵ���1������������û��ʵ�����ơ�
  3����ʱ����ҵ�������ó�����๤����������һ�룬����Ӱ��������ͨ��ҵ����Ӧ�����
  Ͷ�ĳ�ʱ����ҵʱ��Ӧ���Ͷ�Ľ����ȷ���Ƿ�Ͷ�ĳɹ�
  * }
const
  JOB_RUN_ONCE = $000001; // ��ҵֻ����һ��
  JOB_IN_MAINTHREAD = $000002; // ��ҵֻ�������߳�������
  JOB_MAX_WORKERS = $000004; // �����ܶ�Ŀ������ܵĹ������߳���������ҵ���ݲ�֧��
  JOB_LONGTIME = $000008; // ��ҵ��Ҫ�ܳ���ʱ�������ɣ��Ա���ȳ����������������ҵ��Ӱ��
  JOB_SIGNAL_WAKEUP = $000010; // ��ҵ�����ź���Ҫ����
  JOB_TERMINATED = $000020; // ��ҵ����Ҫ�������У����Խ�����
  JOB_GROUPED = $000040; // ��ǰ��ҵ����ҵ���һԱ
  JOB_ANONPROC = $000080; // ��ǰ��ҵ��������������
  JOB_FREE_OBJECT = $000100; // Data��������Object����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_RECORD = $000200; // Data��������Record����ҵ��ɻ�����ʱ�ͷ�
  JOB_FREE_INTERFACE = $000300; // Data��������Interface����ҵ���ʱ����_Release
  JOB_FREE_CUSTOM1 = $000400; // Data�����ĳ�Ա���û�ָ���ķ�ʽ1�ͷ�
  JOB_FREE_CUSTOM2 = $000500; // Data�����ĳ�Ա���û�ָ���ķ�ʽ2�ͷ�
  JOB_FREE_CUSTOM3 = $000600; // Data�����ĳ�Ա���û�ָ���ķ�ʽ3�ͷ�
  JOB_FREE_CUSTOM4 = $000700; // Data�����ĳ�Ա���û�ָ���ķ�ʽ4�ͷ�
  JOB_FREE_CUSTOM5 = $000800; // Data�����ĳ�Ա���û�ָ���ķ�ʽ5�ͷ�
  JOB_FREE_CUSTOM6 = $000900; // Data�����ĳ�Ա���û�ָ���ķ�ʽ6�ͷ�
  JOB_BY_PLAN = $001000; // ��ҵ��Interval��һ��TQPlanMask������ֵ
  JOB_DELAY_REPEAT = $002000; // ��ҵ�Ƕ�������ӳ���ҵ������һ����ɺ󣬲Ż�����´μ��ʱ��
  JOB_DATA_OWNER = $000F00; // ��ҵ��Data��Ա��������
  JOB_HANDLE_SIMPLE_MASK = $00;
  JOB_HANDLE_REPEAT_MASK = $01;
  JOB_HANDLE_SIGNAL_MASK = $02;
  JOB_HANDLE_PLAN_MASK = $03;

  WORKER_ISBUSY = $0001; // ������æµ
  WORKER_PROCESSLONG = $0002; // ��ǰ������һ����ʱ����ҵ
  WORKER_COM_INITED = $0004; // �������ѳ�ʼ��Ϊ֧��COM��״̬(����Windows)
  WORKER_LOOKUP = $0008; // ���������ڲ�����ҵ
  WORKER_EXECUTING = $0010; // ����������ִ����ҵ
  WORKER_EXECUTED = $0020; // �������Ѿ������ҵ
  WORKER_FIRING = $0040; // ���������ڱ����
  WORKER_RUNNING = $0080; // �������߳��Ѿ���ʼ����
  WORKER_CLEANING = $0100; // �������߳�����������ҵ
  DEFAULT_FIRE_TIMEOUT = 15000;
  INVALID_JOB_DATA = Pointer(-1);
  Q1MillSecond = 10; // 1ms
  Q1Second = 10000; // 1s
  Q1Minute = 600000; // 60s/1min
  Q1Hour = 36000000; // 3600s/60min/1hour
  Q1Day = Int64(864000000); // 1day
{$IFNDEF UNICODE}
  wrIOCompletion = TWaitResult(4);
{$ENDIF}

type
  TQJobs = class;
  TQWorker = class;
  TQWorkers = class;
  TQJobGroup = class;
  TQForJobs = class;
  PQSignal = ^TQSignal;
  PQJob = ^TQJob;
  /// <summary>��ҵ�����ص�����</summary>
  /// <param name="AJob">Ҫ��������ҵ��Ϣ</param>
  TQJobProc = procedure(AJob: PQJob) of object;
  PQJobProc = ^TQJobProc;
  TQJobProcG = procedure(AJob: PQJob);
  TQForJobProc = procedure(ALoopMgr: TQForJobs; AJob: PQJob; AIndex: NativeInt)
    of object;
  PQForJobProc = ^TQForJobProc;
  TQForJobProcG = procedure(ALoopMgr: TQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$IFDEF UNICODE}
  TQJobProcA = reference to procedure(AJob: PQJob);
  TQForJobProcA = reference to procedure(ALoopMgr: TQForJobs; AJob: PQJob;
    AIndex: NativeInt);
{$ENDIF}
  /// <summary>��ҵ����ԭ���ڲ�ʹ��</summary>
  /// <remarks>
  /// irNoJob : û����Ҫ��������ҵ����ʱ�����߻�����ͷŵȴ�״̬������ڵȴ�ʱ����
  /// ������ҵ�����������߻ᱻ���ѣ�����ʱ��ᱻ�ͷ�
  /// irTimeout : �������Ѿ��ȴ���ʱ�����Ա��ͷ�
  TWorkerIdleReason = (irNoJob, irTimeout);

  /// <summary>��ҵ����ʱ��δ���Data��Ա</summary>
  /// <remarks>
  /// jdoFreeByUser : �û�����������ͷ�
  /// jdoFreeAsObject : ���ӵ���һ��TObject�̳еĶ�����ҵ���ʱ�����FreeObject�ͷ�
  /// jdfFreeAsSimpleRecord : ���ӵ���һ����¼���ṹ�壩����ҵ���ʱ�����Dispose�ͷ�
  /// ע�������ͷ�ʱʵ������FreeMem���˽ṹ�岻Ӧ�����������ͣ���String/��̬����/Variant����Ҫ
  /// jdtFreeAsInterface : ���ӵ���һ���ӿڶ�������ʱ�����Ӽ�������ҵ���ʱ����ټ���
  /// jdfFreeAsC1 : �û�����ָ�����ͷŷ���1
  /// jdfFreeAsC2 : �û�����ָ�����ͷŷ���2
  /// jdfFreeAsC3 : �û�����ָ�����ͷŷ���3
  /// jdfFreeAsC4 : �û�����ָ�����ͷŷ���4
  /// jdfFreeAsC5 : �Ի�����ָ�����ͷŷ���5
  /// jdfFreeAsC6 : �û�����ָ�����ͷŷ���6
  /// </remarks>
  TQJobDataFreeType = (jdfFreeByUser, jdfFreeAsObject, jdfFreeAsSimpleRecord,
    jdfFreeAsInterface, jdfFreeAsC1, jdfFreeAsC2, jdfFreeAsC3, jdfFreeAsC4,
    jdfFreeAsC5, jdfFreeAsC6);

  TQJobPlanData = record
    OriginData: Pointer;
    Plan: TQPlanMask;
    DataFreeType: TQJobDataFreeType;
  end;

  PQJobPlanData = ^TQJobPlanData;

  TQExtFreeEvent = procedure(AData: Pointer) of object;
  TQExtInitEvent = procedure(var AData: Pointer) of Object;
{$IFDEF UNICODE}
  TQExtInitEventA = reference to procedure(var AData: Pointer);
  TQExtFreeEventA = reference to procedure(AData: Pointer);
{$ENDIF}

  TQJobExtData = class
  private
    function GetAsBoolean: Boolean;
    function GetAsDouble: Double;
    function GetAsInteger: Integer;
    function GetAsString: QStringW;
    procedure SetAsBoolean(const Value: Boolean);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: QStringW);
    function GetAsDateTime: TDateTime;
    procedure SetAsDateTime(const Value: TDateTime);
    function GetAsInt64: Int64;
    procedure SetAsInt64(const Value: Int64);
    function GetAsPlan: PQJobPlanData;
    function GetParamCount: Integer;
    function GetParams(AIndex: Integer): Variant;
  protected
    FOrigin: Pointer;
    FOnFree: TQExtFreeEvent;
{$IFDEF UNICODE}
    FOnFreeA: TQExtFreeEventA;
{$ENDIF}
    procedure DoFreeAsString(AData: Pointer);
    procedure DoSimpleTypeFree(AData: Pointer);
    procedure DoFreeAsPlan(AData: Pointer);
    procedure DoFreeAsVariant(AData: Pointer);
{$IFNDEF NEXTGEN}
    function GetAsAnsiString: AnsiString;
    procedure SetAsAnsiString(const Value: AnsiString);
    procedure DoFreeAsAnsiString(AData: Pointer);
{$ENDIF}
  public
    constructor Create(AData: Pointer; AOnFree: TQExtFreeEvent); overload;
    constructor Create(AOnInit: TQExtInitEvent;
      AOnFree: TQExtFreeEvent); overload;
    constructor Create(const APlan: TQPlanMask; AData: Pointer;
      AFreeType: TQJobDataFreeType); overload;
    constructor Create(const AParams: array of const); overload;
{$IFDEF UNICODE}
    constructor Create(AData: Pointer; AOnFree: TQExtFreeEventA); overload;
    constructor Create(AOnInit: TQExtInitEventA;
      AOnFree: TQExtFreeEventA); overload;
{$ENDIF}
    constructor Create(const Value: Int64); overload;
    constructor Create(const Value: Integer); overload;
    constructor Create(const Value: Boolean); overload;
    constructor Create(const Value: Double); overload;
    constructor CreateAsDateTime(const Value: TDateTime); overload;
    constructor Create(const S: QStringW); overload;
{$IFNDEF NEXTGEN}
    constructor Create(const S: AnsiString); overload;
{$ENDIF}
    destructor Destroy; override;
    property Origin: Pointer read FOrigin;
    property AsString: QStringW read GetAsString write SetAsString;
{$IFNDEF NEXTGEN}
    property AsAnsiString: AnsiString read GetAsAnsiString
      write SetAsAnsiString;
{$ENDIF}
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsFloat: Double read GetAsDouble write SetAsDouble;
    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsPlan: PQJobPlanData read GetAsPlan;
    property Params[AIndex: Integer]: Variant read GetParams;
    property ParamCount: Integer read GetParamCount;
  end;

  TQJobMethod = record
    case Integer of
      0:
        (Proc: {$IFNDEF NEXTGEN}TQJobProc{$ELSE}Pointer{$ENDIF});
      1:
        (ProcG: TQJobProcG);
      2:
        (ProcA: Pointer);
      3:
        (ForProc: {$IFNDEF NEXTGEN}TQForJobProc{$ELSE}Pointer{$ENDIF});
      4:
        (ForProcG: TQForJobProcG);
      5:
        (ForProcA: Pointer);
      6:
        (Code: Pointer; Data: Pointer);
  end;

  TQJob = record
  private
    function GetAvgTime: Integer; inline;
    function GetElapsedTime: Int64; inline;
    function GetIsTerminated: Boolean; inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    procedure UpdateNextTime;
    procedure SetIsTerminated(const Value: Boolean);
    procedure AfterRun(AUsedTime: Int64);
    function GetFreeType: TQJobDataFreeType; inline;
    function GetIsCustomFree: Boolean; inline;
    function GetIsObjectOwner: Boolean; inline;
    function GetIsRecordOwner: Boolean; inline;
    function GetIsInterfaceOwner: Boolean; inline;
    function GetExtData: TQJobExtData; inline;
    procedure SetFreeType(const Value: TQJobDataFreeType);
    function GetHandle: IntPtr;
  public
    constructor Create(AProc: TQJobProc); overload;
    /// <summary>ֵ��������</summary>
    /// <remarks>Worker/Next/Source���Ḵ�Ʋ��ᱻ�ÿգ�Owner���ᱻ����</remarks>
    procedure Assign(const ASource: PQJob);
    /// <summary>�������ݣ��Ա�Ϊ�Ӷ����е�����׼��</summary>
    procedure Reset; inline;

    /// <summary>�������̶߳����ͬ�������������Ƽ�Ͷ���첽��ҵ�����߳��д���</summary>
    procedure Synchronize(AMethod: TThreadMethod); overload;
{$IFDEF UNICODE}inline; {$ENDIF}
{$IFDEF UNICODE}
    procedure Synchronize(AProc: TThreadProcedure); overload; inline;
{$ENDIF}
    /// <summary>ƽ��ÿ������ʱ�䣬��λΪ0.1ms</summary>
    property AvgTime: Integer read GetAvgTime;
    /// <summmary>����������ʱ�䣬��λΪ0.1ms</summary>
    property ElapsedTime: Int64 read GetElapsedTime;
    /// <summary>�Ƿ�ֻ����һ�Σ�Ͷ����ҵʱ�Զ�����</summary>
    property Runonce: Boolean index JOB_RUN_ONCE read GetFlags;
    /// <summary>�Ƿ�Ҫ�������߳�ִ����ҵ��ʵ��Ч���� Windows �� PostMessage ����</summary>
    property InMainThread: Boolean index JOB_IN_MAINTHREAD read GetFlags;
    /// <summary>�Ƿ���һ������ʱ��Ƚϳ�����ҵ����Workers.LongtimeWork����</summary>
    property IsLongtimeJob: Boolean index JOB_LONGTIME read GetFlags;
    /// <summary>�Ƿ���һ���źŴ�������ҵ</summary>
    property IsSignalWakeup: Boolean index JOB_SIGNAL_WAKEUP read GetFlags;
    /// <summary>�Ƿ��Ƿ�����ҵ�ĳ�Ա</summary>
    property IsGrouped: Boolean index JOB_GROUPED read GetFlags;
    /// <summary>�Ƿ�Ҫ�������ǰ��ҵ</summary>
    property IsTerminated: Boolean read GetIsTerminated write SetIsTerminated;
    /// <summary>�ж���ҵ��Dataָ�����һ��������Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsObjectOwner: Boolean read GetIsObjectOwner;
    /// <summary>�ж���ҵ��Dataָ�����һ����¼��Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsRecordOwner: Boolean read GetIsRecordOwner;
    /// <summary>�ж���ҵ��Data�Ƿ������û���ָ���ķ����Զ��ͷ�</summary>
    property IsCustomFree: Boolean read GetIsCustomFree;
    property FreeType: TQJobDataFreeType read GetFreeType write SetFreeType;
    /// <summary>�ж���ҵ�Ƿ�ӵ��Data���ݳ�Ա
    property IsDataOwner: Boolean index JOB_DATA_OWNER read GetFlags;
    /// <summary>�ж���ҵ��Dataָ�����һ���ӿ���Ҫ����ҵ���ʱ�Զ��ͷ�</summary>
    property IsInterfaceOwner: Boolean read GetIsInterfaceOwner;
    /// <summary>�ж���ҵ���������Ƿ���һ����������</summary>
    property IsAnonWorkerProc: Boolean index JOB_ANONPROC read GetFlags
      write SetFlags;
    /// <summary>��ҵ����һ���ƻ����񴥷�</summary>
    property IsByPlan: Boolean index JOB_BY_PLAN read GetFlags write SetFlags;
    /// <summary>��չ����ҵ������������</summary>
    property ExtData: TQJobExtData read GetExtData;
    property IsDelayRepeat: Boolean index JOB_DELAY_REPEAT read GetFlags
      write SetFlags;
    property Handle: IntPtr read GetHandle;
  public
    FirstStartTime: Int64; // ��ҵ��һ�ο�ʼʱ��
    StartTime: Int64; // ������ҵ��ʼʱ��,8B
    PushTime: Int64; // ���ʱ��
    PopTime: Int64; // ����ʱ��
    DoneTime: Int64; // ��ҵ����ʱ��
    NextTime: Int64; // ��һ�����е�ʱ��,+8B=16B
    WorkerProc: TQJobMethod; //
    Owner: TQJobs; // ��ҵ�������Ķ���
    Next: PQJob; // ��һ�����
    Worker: TQWorker; // ��ǰ��ҵ������
    Runs: Integer; // �Ѿ����еĴ���+4B
    MinUsedTime: Cardinal; // ��С����ʱ��+4B
    TotalUsedTime: Cardinal; // �����ܼƻ��ѵ�ʱ�䣬TotalUsedTime/Runs���Եó�ƽ��ִ��ʱ��+4B
    MaxUsedTime: Cardinal; // �������ʱ��+4B
    Flags: Integer; // ��ҵ��־λ+4B
    Data: Pointer; // ������������
    case Integer of
      0:
        (SignalId: Integer; // �źű���
          RefCount: PInteger; // Դ����
          Reserved: Int64; // ���⸲���ظ���ҵ��FirstDelay
          Source: PQJob; // Դ��ҵ��ַ
        );
      1:
        (Interval: Int64; // ����ʱ��������λΪ0.1ms��ʵ�ʾ����ܲ�ͬ����ϵͳ����+8B
          FirstDelay: Int64; // �״������ӳ٣���λΪ0.1ms��Ĭ��Ϊ0
        );
      2: // ������ҵ֧��
        (Group: Pointer;
        );
      3:
        (PlanJob: Pointer;
        );
  end;

  /// <summary>��ҵ״̬����PeekJobState��������</summary>
  TQJobState = record
    Handle: IntPtr; // ��ҵ������
    Proc: TQJobMethod; // ��ҵ����
    Flags: Integer; // ��־λ
    IsRunning: Boolean; // �Ƿ��������У����ΪFalse������ҵ���ڶ�����
    Runs: Integer; // �Ѿ����еĴ���
    EscapedTime: Int64; // �Ѿ�ִ��ʱ��
    PushTime: Int64; // ���ʱ��
    PopTime: Int64; // ����ʱ��
    AvgTime: Int64; // ƽ��ʱ��
    TotalTime: Int64; // ��ִ��ʱ��
    MaxTime: Int64; // ���ִ��ʱ��
    MinTime: Int64; // ��Сִ��ʱ��
    NextTime: Int64; // �ظ���ҵ���´�ִ��ʱ��
    Plan: TQPlanMask; // �ƻ���������
  end;

  TQJobStateArray = array of TQJobState;

  PQJobWaitChain = ^TQJobWaitChain;

  TQJobWaitChain = record
    Job: IntPtr;
    Event: Pointer;
    Prior: PQJobWaitChain;
  end;

  /// <summary>�����߼�¼�ĸ�������</summary>
  // TQJobHelper = record helper for TQJob
  //
  // end;

  // ��ҵ���ж���Ļ��࣬�ṩ�����Ľӿڷ�װ
  TQJobs = class
  protected
    FOwner: TQWorkers;
    function InternalPush(AJob: PQJob): Boolean; virtual; abstract;
    function InternalPop: PQJob; virtual; abstract;
    function GetCount: Integer; virtual; abstract;
    function GetEmpty: Boolean;
    /// <summary>Ͷ��һ����ҵ</summary>
    /// <param name="AJob">ҪͶ�ĵ���ҵ</param>
    /// <remarks>�ⲿ��Ӧ����ֱ��Ͷ�����񵽶��У�����TQWorkers����Ӧ�����ڲ����á�</remarks>
    function Push(AJob: PQJob): Boolean; virtual;
    /// <summary>����һ����ҵ</summary>
    /// <returns>���ص�ǰ����ִ�еĵ�һ����ҵ</returns>
    function Pop: PQJob; virtual;
    /// <summary>���������ҵ</summary>
    procedure Clear; overload; virtual;
    /// <summary>���ָ������ҵ</summary>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; virtual; abstract;
    /// <summary>���һ�����������������ҵ</summary>
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer; overload;
      virtual; abstract;
    /// <summary>���ݾ�����һ����ҵ����</summary>
    function Clear(AHandle: IntPtr): Boolean; overload; virtual;
    /// <summary>���ݾ���б����һ����ҵ����</summary>
    function ClearJobs(AHandes: PIntPtr; ACount: Integer): Integer; overload;
      virtual; abstract;
  public
    constructor Create(AOwner: TQWorkers); overload; virtual;
    destructor Destroy; override;
    /// ���ɿ����棺Count��Emptyֵ����һ���ο����ڶ��̻߳����¿��ܲ�����֤��һ�����ִ��ʱ����һ��
    property Empty: Boolean read GetEmpty; // ��ǰ�����Ƿ�Ϊ��
    property Count: Integer read GetCount; // ��ǰ����Ԫ������
  end;

  TQSimpleLock = TCriticalSection;

  // TQSimpleJobs���ڹ����򵥵��첽���ã�û�д���ʱ��Ҫ�����ҵ
  TQSimpleJobs = class(TQJobs)
  protected
    FFirst, FLast: PQJob;
    FCount: Integer;
    FLocker: TQSimpleLock;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function GetCount: Integer; override;
    procedure Clear; overload; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
    function Clear(AHandle: IntPtr): Boolean; overload; override;
    function ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
      overload; override;
    function PopAll: PQJob;
    procedure Repush(ANewFirst: PQJob);
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  // TQRepeatJobs���ڹ����ƻ���������Ҫ��ָ����ʱ��㴥��
  TQRepeatJobs = class(TQJobs)
  protected
    FItems: TQRBTree;
    FLocker: TCriticalSection;
    FFirstFireTime: Int64;
    function InternalPush(AJob: PQJob): Boolean; override;
    function InternalPop: PQJob; override;
    function DoTimeCompare(P1, P2: Pointer): Integer;
    procedure DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
    function GetCount: Integer; override;
    procedure Clear; override;
    function Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
      overload; override;
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer)
      : Integer; overload; override;
    function Clear(AHandle: IntPtr): Boolean; overload; override;
    function ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
      overload; override;
    procedure AfterJobRun(AJob: PQJob; AUsedTime: Int64);
  public
    constructor Create(AOwner: TQWorkers); override;
    destructor Destroy; override;
  end;

  { �������߳�ʹ�õ������������������ǽ��������������Ϊ���ڹ������������ޣ�����
    �Ĵ�����������ֱ����򵥵�ѭ��ֱ����Ч
  }
  TQWorker = class(TThread)
  private
  protected
    FOwner: TQWorkers;
    FEvent: TEvent;
    FTimeout: Cardinal;
    FFireDelay: Cardinal;
    FFlags: Integer;
    FProcessed: Cardinal;
    FActiveJobFlags: Integer;
    FActiveJob: PQJob;
    // ֮���Բ�ֱ��ʹ��FActiveJob����ط���������Ϊ��֤�ⲿ�����̰߳�ȫ�ķ�����������Ա
    FActiveJobProc: TQJobMethod;
    FActiveJobData: Pointer;
    FActiveJobSource: PQJob;
    FActiveJobGroup: TQJobGroup;
    FTerminatingJob: PQJob;
    FLastActiveTime: Int64;
    FPending: Boolean; // �Ѿ��ƻ���ҵ
    procedure Execute; override;
    procedure FireInMainThread;
    procedure DoJob(AJob: PQJob);
    function GetIsIdle: Boolean; inline;
    procedure SetFlags(AIndex: Integer; AValue: Boolean); inline;
    function GetFlags(AIndex: Integer): Boolean; inline;
    function WaitSignal(ATimeout: Integer; AByRepeatJob: Boolean)
      : TWaitResult; inline;
  public
    constructor Create(AOwner: TQWorkers); overload;
    destructor Destroy; override;
    procedure ComNeeded(AInitFlags: Cardinal = 0);
    /// <summary>�жϵ�ǰ�Ƿ��ڳ�ʱ����ҵ����������</summary>
    property InLongtimeJob: Boolean index WORKER_PROCESSLONG read GetFlags;
    /// <summary>�жϵ�ǰ�Ƿ����</summary>
    property IsIdle: Boolean read GetIsIdle;
    /// <summary>�жϵ�ǰ�Ƿ�æµ</summary>
    property IsBusy: Boolean index WORKER_ISBUSY read GetFlags;
    property IsLookuping: Boolean index WORKER_LOOKUP read GetFlags;
    property IsExecuting: Boolean index WORKER_EXECUTING read GetFlags;
    property IsExecuted: Boolean index WORKER_EXECUTED read GetFlags;
    property IsFiring: Boolean index WORKER_FIRING read GetFlags;
    property IsRunning: Boolean index WORKER_RUNNING read GetFlags;
    property IsCleaning: Boolean index WORKER_CLEANING read GetFlags;
    /// <summary>�ж�COM�Ƿ��Ѿ���ʼ��Ϊ֧��COM
    property ComInitialized: Boolean index WORKER_COM_INITED read GetFlags;
  end;

  /// <summary>�źŵ��ڲ�����</summary>
  TQSignal = record
    Id: Integer;
    /// <summary>�źŵı���</summary>
    Fired: Integer; // <summary>�ź��Ѵ�������</summary>
    Name: QStringW;
    /// <summary>�źŵ�����</summary>
    First: PQJob;
    /// <summary>�׸���ҵ</summary>
  end;

  TWorkerWaitParam = record
    WaitType: Byte;
    Data: Pointer;
    case Integer of
      0:
        (Bound: Pointer); // ���������
      1:
        (WorkerProc: TMethod;);
      2:
        (SourceJob: PQJob);
      3:
        (Group: Pointer);
  end;
  /// <summary>������Դ����ȡֵ������
  /// jesExecute : ִ��ʱ����
  /// jesFreeData : �ͷŸ�������ʱ����
  /// jesWaitDone : �ڵȴ���ҵ���ʱ����
  /// </summary>

  TJobErrorSource = (jesExecute, jesFreeData, jesWaitDone);
  // For����������ֵ����
  TForLoopIndexType = {$IF RTLVersion>=26}NativeInt{$ELSE}Integer{$IFEND};
  /// <summary>�����ߴ���֪ͨ�¼�</summary>
  /// <param name="AJob">�����������ҵ����</param>
  /// <param name="E">���������쳣����</param>
  /// <param name="ErrSource">������Դ</param>
  TWorkerErrorNotify = procedure(AJob: PQJob; E: Exception;
    const ErrSource: TJobErrorSource) of object;
  // �Զ��������ͷ��¼�
  TQCustomFreeDataEvent = procedure(ASender: TQWorkers;
    AFreeType: TQJobDataFreeType; const AData: Pointer);

  TQWorkerStatusItem = record
    LastActive: Int64;
    Processed: Cardinal;
    ThreadId: TThreadId;
    IsIdle: Boolean;
    ActiveJob: QStringW;
    Stacks: QStringW;
    Timeout: Cardinal;
  end;

  TQWorkerStatus = array of TQWorkerStatusItem;

  /// <summary>�����߹��������������������ߺ���ҵ</summary>
  TQWorkers = class
  protected
    FWorkers: array of TQWorker;
    FDisableCount: Integer;
    FMinWorkers: Integer;
    FMaxWorkers: Integer;
    FWorkerCount: Integer;
    FBusyCount: Integer;
    FFiringWorkerCount: Integer;
    FFireTimeout: Cardinal;
    FLongTimeWorkers: Integer; // ��¼�³�ʱ����ҵ�еĹ����ߣ���������ʱ�䲻�ͷ���Դ�����ܻ�������������޷���ʱ��Ӧ
    FMaxLongtimeWorkers: Integer; // �������ͬʱִ�еĳ�ʱ��������������������MaxWorkers��һ��
    FLocker: TCriticalSection;
    FSimpleJobs: TQSimpleJobs;
    FPlanJobs: TQSimpleJobs; // �ƻ����񣬻�ÿ���Ӽ��һ�������Ƿ�����Ҫִ�е���ҵ
    FRepeatJobs: TQRepeatJobs;
    FSignalJobs: TQHashTable;
    FMaxSignalId: Integer;
    FTerminating: Boolean;
    FStaticThread: TThread;
    FPlanCheckJob: IntPtr;
    FOnError: TWorkerErrorNotify;
    FLastWaitChain: PQJobWaitChain;
    FOnCustomFreeData: TQCustomFreeDataEvent;
{$IFDEF MSWINDOWS}
    FMainWorker: HWND;
    procedure DoMainThreadWork(var AMsg: TMessage);
{$ENDIF}
    function Popup: PQJob;
    procedure SetMaxWorkers(const Value: Integer);
    function GetEnabled: Boolean;
    procedure SetEnabled(const Value: Boolean);
    procedure SetMinWorkers(const Value: Integer);
    procedure WorkerTimeout(AWorker: TQWorker); inline;
    procedure WorkerTerminate(AWorker: TQWorker);
    procedure FreeJob(AJob: PQJob);
    function LookupIdleWorker(AFromStatic: Boolean): Boolean;
    procedure ClearWorkers;
    procedure SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
    procedure DoJobFree(ATable: TQHashTable; AHash: Cardinal; AData: Pointer);
    function Post(AJob: PQJob): IntPtr; overload;
    procedure SetMaxLongtimeWorkers(const Value: Integer);
    function SignalIdByName(const AName: QStringW): Integer;
    procedure FireSignalJob(ASignal: PQSignal; AData: Pointer;
      AFreeType: TQJobDataFreeType);
    function ClearSignalJobs(ASource: PQJob;
      AWaitRunningDone: Boolean = True): Integer;
    procedure WaitSignalJobsDone(AJob: PQJob);
    procedure WaitRunningDone(const AParam: TWorkerWaitParam);
    procedure FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
    procedure DoCustomFreeData(AFreeType: TQJobDataFreeType;
      const AData: Pointer);
    function GetIdleWorkers: Integer; inline;
    function GetBusyCount: Integer; inline;
    function GetOutWorkers: Boolean; inline;
    procedure SetFireTimeout(const Value: Cardinal);
    procedure ValidWorkers; inline;
    procedure NewWorkerNeeded;
    function CreateWorker(ASuspended: Boolean): TQWorker;
    function GetNextRepeatJobTime: Int64; inline;
    procedure DoPlanCheck(AJob: PQJob);
    procedure AfterPlanRun(AJob: PQJob; AUsedTime: Int64);
    function HandleToJob(const AHandle: IntPtr): PQJob;
    procedure PlanCheckNeeded;
    procedure CheckWaitChain(AJob: PQJob);
  public
    constructor Create(AMinWorkers: Integer = 2); overload;
    destructor Destroy; override;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨������ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;

{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AInterval">Ҫ��ʱִ�е���ҵʱ��������λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = False)
      : IntPtr; overload;
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = False)
      : IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ӳٿ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ADelay">Ҫ�ӳٵ�ʱ�䣬��λΪ0.1ms����Ҫ���1�룬��ֵΪ10000</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <param name="ARepeat">�Ƿ�����һ����ҵ��ɺ��ٴ��ӳ�</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser; ARepeat: Boolean = False)
      : IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProc; ASignalId: Integer;
      ARunInMainThread: Boolean = False): IntPtr; overload;
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcG; ASignalId: Integer;
      ARunInMainThread: Boolean = False): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ȴ��źŲſ�ʼ����ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="ASignalId">�ȴ����źű��룬�ñ�����RegisterSignal��������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Wait(AProc: TQJobProcA; ASignalId: Integer;
      ARunInMainThread: Boolean = False): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ADelay">��һ��ִ��ǰ���ӳ�ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
      AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProc; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcG; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����ָ��ʱ��ſ�ʼ���ظ���ҵ</summary>
    /// <param name="AProc">Ҫ��ʱִ�е���ҵ����</param>
    /// <param name="ATime">ִ��ʱ��</param>
    /// <param name="AInterval">������ҵ�ظ���������С�ڵ���0������ҵִֻ��һ�Σ���Delay��Ч��һ��</param>
    /// <param name="ARunInMainThread">�Ƿ�Ҫ����ҵ�����߳���ִ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function At(AProc: TQJobProcA; const ATime: TDateTime;
      const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProc; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcG; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: TQPlanMask; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ���ƻ�������ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="APlan">Ҫִ�еļƻ���������</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="ARunInMainThread">��ҵҪ�������߳���ִ��</param>
    /// <returns>�ɹ�Ͷ�ķ��ؾ�������򷵻�0</returns>
    function Plan(AProc: TQJobProcA; const APlan: QStringW; AData: Pointer;
      ARunInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProc; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProcG; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$IFDEF UNICODE}
    /// <summary>Ͷ��һ����̨��ʱ��ִ�е���ҵ</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��ҵ���ӵ��û�����ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�Ͷ�ķ���True�����򷵻�False</returns>
    /// <remarks>��ʱ����ҵǿ���ں�̨�߳���ִ�У���������Ͷ�ݵ����߳���ִ��</remarks>
    /// <returns>�ɹ�Ͷ�ķ��ؾ����ʧ�ܷ���0</returns>
    function LongtimeJob(AProc: TQJobProcA; AData: Pointer;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr; overload;
{$ENDIF}
    /// <summary>���������ҵ</summary>
    procedure Clear; overload;
    /// <summary>���һ��������ص�������ҵ</summary>
    /// <param name="AObject">Ҫ�ͷŵ���ҵ�������̹�������</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <returns>����ʵ���������ҵ����</returns>
    /// <remarks>һ����������ƻ�����ҵ�������Լ��ͷ�ǰӦ���ñ������������������ҵ��
    /// ����δ��ɵ���ҵ���ܻᴥ���쳣��</remarks>
    function Clear(AObject: Pointer; AMaxTimes: Integer = -1): Integer;
      overload;
    /// <summary>�������Ͷ�ĵ�ָ��������ҵ</summary>
    /// <param name="AProc">Ҫ�������ҵִ�й���</param>
    /// <param name="AData">Ҫ�������ҵ��������ָ���ַ�����ֵΪPointer(-1)��
    /// ��������е���ع��̣�����ֻ����������ݵ�ַһ�µĹ���</param>
    /// <param name="AMaxTimes">�����������������<0����ȫ��</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(AProc: TQJobProc; AData: Pointer; AMaxTimes: Integer = -1)
      : Integer; overload;
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalName">Ҫ������ź�����</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalName: QStringW): Integer; overload;
    /// <summary>���ָ���źŹ�����������ҵ</summary>
    /// <param name="ASingalId">Ҫ������ź�ID</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function Clear(ASignalId: Integer): Integer; overload;
    /// <summary>���ָ�������Ӧ����ҵ</summary>
    /// <param name="ASingalId">Ҫ�������ҵ���</param>
    /// <param name="AWaitRunningDone">�����ҵ����ִ���У��Ƿ�ȴ����</param>
    /// <returns>����ʵ���������ҵ����</returns>
    procedure ClearSingleJob(AHandle: IntPtr;
      AWaitRunningDone: Boolean = True); overload;

    /// <summary>���ָ���ľ���б��ж�Ӧ����ҵ</summary>
    /// <param name="AHandles">��Post/At��Ͷ�ݺ������صľ���б�</param>
    /// <parma name="ACount">AHandles��Ӧ�ľ������</param>
    /// <returns>����ʵ���������ҵ����</returns>
    function ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer; overload;
    /// <summary>����һ���ź�</summary>
    /// <param name="AId">�źű��룬��RegisterSignal����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    procedure Signal(AId: Integer; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser); overload;
    /// <summary>�����ƴ���һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <param name="AData">���Ӹ���ҵ���û�����ָ���ַ</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <remarks>����һ���źź�QWorkers�ᴥ��������ע����źŹ����������̵�ִ��</remarks>
    procedure Signal(const AName: QStringW; AData: Pointer = nil;
      AFreeType: TQJobDataFreeType = jdfFreeByUser); overload;
    /// <summary>ע��һ���ź�</summary>
    /// <param name="AName">�ź�����</param>
    /// <remarks>
    /// 1.�ظ�ע��ͬһ���Ƶ��źŽ�����ͬһ������
    /// 2.�ź�һ��ע�ᣬ��ֻ�г����˳�ʱ�Ż��Զ��ͷ�
    /// </remarks>
    function RegisterSignal(const AName: QStringW): Integer; // ע��һ���ź�����
    /// <summary>���ù�����</summary>
    /// <remarks>��DisableWorkers�������ʹ��</remarks>
    procedure EnableWorkers;
    /// <summary>�������й�����</summary>
    /// <remarks>�������й����߽�ʹ�������޷���ȡ���µ���ҵ��ֱ������EnableWorkers</remarks>
    procedure DisableWorkers;
    /// <summary>ö�����й�����״̬</summary>
    function EnumWorkerStatus: TQWorkerStatus;
    /// <summary>��ȡָ����ҵ��״̬</summary>
    /// <param name="AHandle">��ҵ������</param>
    /// <param name="AResult">��ҵ����״̬</param>
    /// <returns>���ָ������ҵ���ڣ��򷵻�True�����򣬷���False</returns>
    /// <remarks>
    /// 1.����ִֻ��һ�ε���ҵ����ִ����󲻸����ڣ�����Ҳ�᷵��false
    /// 2.��FMXƽ̨�����ʹ��������������ҵ���̣�������� ClearJobState ������ִ���������̣��Ա����ڴ�й¶��
    /// </remarks>
    function PeekJobState(AHandle: IntPtr; var AResult: TQJobState): Boolean;
    /// <summary>ö�����е���ҵ״̬</summary>
    /// <returns>������ҵ״̬�б�</summary>
    /// <remarks>��FMXƽ̨�����ʹ��������������ҵ���̣�������� ClearJobStates ������ִ����������</remarks>
    function EnumJobStates: TQJobStateArray;
    /// <summary>�ȴ�ָ������ҵ����</summary>
    /// <param name="AHandle">Ҫ�ȴ�����ҵ������</param>
    /// <param name="ATimeout">��ʱʱ�䣬��λΪ����</param>
    /// <param name="AMsgWait">�ȴ�ʱ�Ƿ���Ӧ��Ϣ</param>
    /// <returns>�����ҵ������ͨ��ҵ���򷵻�wrError�������ҵ�����ڻ��Ѿ����������� wrSignal�����򣬷��� wrTimeout</returns>
    function WaitJob(AHandle: IntPtr; ATimeout: Cardinal; AMsgWait: Boolean)
      : TWaitResult;
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProc; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;
{$IFDEF UNICODE}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcA; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;
{$ENDIF}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcG; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static; inline;

    /// <summary>�����������������������С��2</summary>
    property MaxWorkers: Integer read FMaxWorkers write SetMaxWorkers;
    /// <summary>��С����������������С��2<summary>
    property MinWorkers: Integer read FMinWorkers write SetMinWorkers;
    /// <summary>��������ĳ�ʱ����ҵ�������������ȼ���������ʼ�ĳ�ʱ����ҵ����</summary>
    property MaxLongtimeWorkers: Integer read FMaxLongtimeWorkers
      write SetMaxLongtimeWorkers;
    /// <summary>�Ƿ�������ʼ��ҵ�����Ϊfalse����Ͷ�ĵ���ҵ�����ᱻִ�У�ֱ���ָ�ΪTrue</summary>
    /// <remarks>EnabledΪFalseʱ�Ѿ����е���ҵ����Ȼ���У���ֻӰ����δִ�е�����</remarks>
    property Enabled: Boolean read GetEnabled write SetEnabled;
    /// <summary>�Ƿ������ͷ�TQWorkers��������</summary>
    property Terminating: Boolean read FTerminating;
    /// <summary>��ǰ����������</summary>
    property Workers: Integer read FWorkerCount;
    /// <summary>��ǰæµ����������</summary>
    property BusyWorkers: Integer read GetBusyCount;
    /// <summary>��ǰ���й���������</summary>
    property IdleWorkers: Integer read GetIdleWorkers;
    /// <summary>�Ƿ��Ѿ����������������</summary>
    property OutOfWorker: Boolean read GetOutWorkers;
    /// <summary>Ĭ�Ͻ�͹����ߵĳ�ʱʱ��</summary>
    property FireTimeout: Cardinal read FFireTimeout write SetFireTimeout;
    /// <summary>�û�ָ������ҵ��Data�����ͷŷ�ʽ</summary>
    property OnCustomFreeData: TQCustomFreeDataEvent read FOnCustomFreeData
      write FOnCustomFreeData;
    /// <summary>��һ���ظ���ҵ����ʱ��</summary>
    property NextRepeatJobTime: Int64 read GetNextRepeatJobTime;
    /// <summary>��ִ����ҵ����ʱ�������Ա㴦���쳣</summayr>
    property OnError: TWorkerErrorNotify read FOnError write FOnError;
  end;
{$IFDEF UNICODE}

  TQJobItemList = TList<PQJob>;
{$ELSE}
  TQJobItemList = TList;
{$ENDIF}

  TQJobGroup = class
  protected
    FEvent: TEvent; // �¼������ڵȴ���ҵ���
    FLocker: TQSimpleLock;
    FItems: TQJobItemList; // ��ҵ�б�
    FPrepareCount: Integer; // ׼������
    FByOrder: Boolean; // �Ƿ�˳�򴥷���ҵ��������ȴ���һ����ҵ��ɺ��ִ����һ��
    FTimeoutCheck: Boolean; // �Ƿ�����ҵ��ʱ
    FAfterDone: TNotifyEvent; // ��ҵ����¼�֪ͨ
    FWaitResult: TWaitResult;
    FRuns: Integer; // �Ѿ����е�����
    FPosted: Integer; // �Ѿ��ύ��QWorkerִ�е�����
    FTag: Pointer;
    FCanceled: Integer;
    FFreeAfterDone: Boolean;
    function GetCount: Integer;
    procedure DoJobExecuted(AJob: PQJob);
    procedure DoJobsTimeout(AJob: PQJob);
    procedure DoAfterDone;
    function InitGroupJob(AData: Pointer; AInMainThread: Boolean;
      AFreeType: TQJobDataFreeType): PQJob;
    function InternalAddJob(AJob: PQJob): Boolean;
    function InternalInsertJob(AIndex: Integer; AJob: PQJob): Boolean;
  public
    /// <summary>���캯��</summary>
    /// <param name="AByOrder">ָ���Ƿ���˳����ҵ�����ΪTrue������ҵ�ᰴ����ִ��</param>
    constructor Create(AByOrder: Boolean = False); overload;
    /// <summary>��������</summary>
    destructor Destroy; override;
    /// <summary>ȡ��ʣ��δִ�е���ҵִ��</summary>
    /// <param name="AWaitRunningDone">�Ƿ�ȴ�����ִ�е���ҵִ����ɣ�Ĭ��ΪTrue</param>
    /// <remark>������ڷ��������ҵ�е���Cancel��AWaitRunningDoneһ��Ҫ����ΪFalse��
    /// �������Ҫ�ȴ�����������ִ�е���ҵ��ɣ����������ΪTrue�����򣬿�������ΪFalse</remark>
    procedure Cancel(AWaitRunningDone: Boolean = True);
    /// <summary>Ҫ׼��������ҵ��ʵ�������ڲ�������</summary>
    /// <remarks>Prepare��Run����ƥ��ʹ�ã�������������ҵ���ᱻִ��</remarks>
    procedure Prepare;
    /// <summary>�����ڲ��������������������Ϊ0����ʼʵ��ִ����ҵ</summary>
    /// <param name="ATimeout">�ȴ�ʱ������λΪ����</param>
    procedure Run(ATimeout: Cardinal = INFINITE);
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProc; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProcG; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AIndex">Ҫ����ĵ�λ������</param>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Insert(AIndex: Integer; AProc: TQJobProcA; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProc; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProcG; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$IFDEF UNICODE}
    /// <summary>����һ����ҵ���̣����׼���ڲ�������Ϊ0����ֱ��ִ�У�����ֻ���ӵ��б�</summary>
    /// <param name="AProc">Ҫִ�е���ҵ����</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AInMainThread">��ҵ�Ƿ���Ҫ�����߳���ִ��</param>
    /// <param name="AFreeType">ADataָ���ĸ�������ָ���ͷŷ�ʽ</param>
    /// <returns>�ɹ�������True��ʧ�ܣ�����False</returns>
    /// <remarks>���ӵ������е���ҵ��Ҫôִ����ɣ�Ҫô��ȡ����������ͨ�����ȡ��</remarks>
    function Add(AProc: TQJobProcA; AData: Pointer;
      AInMainThread: Boolean = False;
      AFreeType: TQJobDataFreeType = jdfFreeByUser): Boolean; overload;
{$ENDIF}
    /// <summary>�ȴ���ҵ���</summary>
    /// <param name="ATimeout">��ȴ�ʱ�䣬��λΪ����</param>
    /// <returns>���صȴ����</returns>
    /// <remarks>WaitFor��������ǰ�̵߳�ִ�У���������߳��е��ã�����ʹ��MsgWaitFor
    /// �Ա�֤�������е���ҵ�ܹ���ִ��</remarks>
    function WaitFor(ATimeout: Cardinal = INFINITE): TWaitResult; overload;
    /// <summary>�ȴ���ҵ���</summary>
    /// <param name="ATimeout">��ȴ�ʱ�䣬��λΪ����</param>
    /// <returns>���صȴ����</returns>
    /// <remarks>�����ǰ�����߳���ִ��,MsgWaitFor�����Ƿ�����Ϣ��Ҫ��������
    /// WaitFor���ᣬ����ں�̨�߳���ִ�У���ֱ�ӵ���WaitFor����ˣ������߳��е���
    /// WaitFor��Ӱ�����߳�����ҵ��ִ�У���MsgWaitFor����
    /// </remarks>
    function MsgWaitFor(ATimeout: Cardinal = INFINITE): TWaitResult;
    /// <summary>δ��ɵ���ҵ����</summary>
    property Count: Integer read GetCount;
    /// <summary>ȫ����ҵִ�����ʱ�����Ļص��¼�</summary>
    property AfterDone: TNotifyEvent read FAfterDone write FAfterDone;
    /// <summary>�Ƿ��ǰ�˳��ִ�У�ֻ���ڹ��캯����ָ�����˴�ֻ��</summary>
    property ByOrder: Boolean read FByOrder;
    /// <summary>�û��Զ��ķ��鸽�ӱ�ǩ</summary>
    property Tag: Pointer read FTag write FTag;
    /// <summary>�Ƿ�����ҵ��ɺ��Զ��ͷ�����</summary>
    property FreeAfterDone: Boolean read FFreeAfterDone write FFreeAfterDone;
    /// <summary>��ִ����ɵ���ҵ����</summary>
    property Runs: Integer read FRuns;
  end;

  TQForJobs = class
  private
    FStartIndex, FStopIndex, FIterator: TForLoopIndexType;
    FBreaked: Integer;
    FEvent: TEvent;
    FWorkerCount: Integer;
    FWorkJob: PQJob;
    procedure DoJob(AJob: PQJob);
    procedure Start;
    function Wait(AMsgWait: Boolean): TWaitResult;
    function GetBreaked: Boolean;
    function GetRuns: Cardinal; inline;
    function GetTotalTime: Cardinal; inline;
    function GetAvgTime: Cardinal; inline;
  public
    constructor Create(const AStartIndex, AStopIndex: TForLoopIndexType;
      AData: Pointer; AFreeType: TQJobDataFreeType); overload;
    destructor Destroy; override;
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProc; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
{$IFDEF UNICODE}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcA; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
{$ENDIF}
    /// <summary>��ָ����������ʼ����ִ��ָ���Ĺ��̵���������</summary>
    /// <param name="AStartIndex">��ʼ����</param>
    /// <param name="AStopIndex">��������������</param>
    /// <param name="AWorkerProc">Ҫִ�еĹ���</param>
    /// <param name="AMsgWiat">�ȴ���ҵ��ɹ������Ƿ���Ӧ��Ϣ</param>
    /// <param name="AData">��������ָ��</param>
    /// <param name="AFreeType">��������ָ���ͷŷ�ʽ</param>
    /// <returns>����ѭ���ȴ����</returns>
    class function &For(const AStartIndex, AStopIndex: TForLoopIndexType;
      AWorkerProc: TQForJobProcG; AMsgWait: Boolean = False;
      AData: Pointer = nil; AFreeType: TQJobDataFreeType = jdfFreeByUser)
      : TWaitResult; overload; static;
    /// <summary>�ж�ѭ����ִ��</summary>
    procedure BreakIt;
    /// <summary>��ʼ����</summary>
    property StartIndex: TForLoopIndexType read FStartIndex;
    /// <summary>��������</summary>
    property StopIndex: TForLoopIndexType read FStopIndex;
    /// <summary>���ж�</summary>
    property Breaked: Boolean read GetBreaked;
    /// <summary>�����д���<summary>
    property Runs: Cardinal read GetRuns;
    /// <summary>������ʱ�䣬����Ϊ0.1ms</summary>
    property TotalTime: Cardinal read GetTotalTime;
    /// <summary>ƽ��ÿ�ε�����ʱ������Ϊ0.1ms</summary>
    property AvgTime: Cardinal read GetAvgTime;
  end;

type
  TGetThreadStackInfoFunction = function(AThread: TThread): QStringW;
  TMainThreadProc = procedure(AData: Pointer) of object;
  TMainThreadProcG = procedure(AData: Pointer);
  /// <summary>��ȫ�ֵ���ҵ��������ת��ΪTQJobProc���ͣ��Ա���������ʹ��</summary>
  /// <param name="AProc">ȫ�ֵ���ҵ��������</param>
  /// <returns>�����µ�TQJobProcʵ��</returns>
function MakeJobProc(const AProc: TQJobProcG): TQJobProc; overload;
// ��ȡϵͳ��CPU�ĺ�������
function GetCPUCount: Integer;
// ��ȡ��ǰϵͳ��ʱ�������߿ɾ�ȷ��0.1ms����ʵ���ܲ���ϵͳ����
function GetTimestamp: Int64;
// �����߳����е�CPU
procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
// ԭ������������
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer;
// ԭ������������
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer;
/// <summary>��ȡ��ҵ������л������ҵ��������</summary>
function JobPoolCount: NativeInt;
/// <summary>��ӡ��ҵ���л������ҵ������Ϣ</summary>
function JobPoolPrint: QStringW;
/// <summary>���ָ����ҵ״̬��״̬��Ϣ</summary>
/// <param name="AState">��ҵ״̬</param>
procedure ClearJobState(var AState: TQJobState); inline;
/// <summary>���ָ����ҵ״̬�����״̬��Ϣ</summary>
/// <param name="AStates">��ҵ״̬����</param>
procedure ClearJobStates(var AStates: TQJobStateArray);
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
/// <param name="AData">���Ӳ���</param>
procedure RunInMainThread(AProc: TMainThreadProc; AData: Pointer); overload;
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
/// <param name="AData">���Ӳ���</param>
procedure RunInMainThread(AProc: TMainThreadProcG; AData: Pointer); overload;
{$IFDEF UNICODE}
/// <summary>�����߳���ִ��ָ���ĺ���</summary>
/// <param name="AProc">Ҫִ�еĺ���</param>
procedure RunInMainThread(AProc: TThreadProcedure); overload;
{$ENDIF}
/// <summary>�ж�ָ���߳�ID��Ӧ�ĺ����Ƿ����</summary>
/// <param name="AThreadId">�߳�ID</param>
/// <param name="AProcessId">����ID�����Ϊ$FFFFFFFF���򲻼�飬���Ϊ0����Ϊ��ǰ����</param>
/// <returns>������ڣ��򷵻�True�����򷵻�False</returns>
function ThreadExists(AThreadId: TThreadId; AProcessId: DWORD = 0): Boolean;
/// <summary>��������Ϣѭ�����ȴ�ĳһ�¼�����</summary>
/// <param name="AEvent">Ҫ�ȴ��������¼�</param>
/// <param name="ATimeout">�ȴ���ʱʱ�䣬��λ����</param>
/// <returns>���صȴ����</returns>
function MsgWaitForEvent(AEvent: TEvent; ATimeout: Cardinal): TWaitResult;

var
  Workers: TQWorkers;
  GetThreadStackInfo: TGetThreadStackInfoFunction;

implementation

{$IFDEF USE_MAP_SYMBOLS}

uses qmapsymbols;
{$ENDIF}

resourcestring
  SNotSupportNow = '��ǰ��δ֧�ֹ��� %s';
  STooFewWorkers = 'ָ������С����������̫��(������ڵ���1)��';
  SMaxMinWorkersError = 'ָ������С���������������������������';
  STooManyLongtimeWorker = '��������̫�೤ʱ����ҵ�߳�(�������������һ��)��';
  SBadWaitDoneParam = 'δ֪�ĵȴ�����ִ����ҵ��ɷ�ʽ:%d';
  SUnsupportPlatform = '%s ��ǰ�ڱ�ƽ̨����֧�֡�';

type
{$IFDEF MSWINDOWS}
  TGetTickCount64 = function: Int64;
  TGetSystemTimes = function(var lpIdleTime, lpKernelTime,
    lpUserTime: TFileTime): BOOL; stdcall;
{$ENDIF MSWINDOWS}

  TJobPool = class
  protected
    FFirst: PQJob;
    FCount: Integer;
    FSize: Integer;
    FLocker: TQSimpleLock;
  public
    constructor Create(AMaxSize: Integer); overload;
    destructor Destroy; override;
    procedure Push(AJob: PQJob);
    function Pop: PQJob;
    property Count: Integer read FCount;
    property Size: Integer read FSize write FSize;
  end;
{$IF RTLVersion<24}

  TSystemTimes = record
    IdleTime, UserTime, KernelTime, NiceTime: UInt64;
  end;
{$IFEND <XE3}

  TStaticThread = class(TThread)
  protected
    FEvent: TEvent;
    FLastTimes:
{$IF RTLVersion>=24}TThread.{$IFEND >=XE5}TSystemTimes;
    procedure Execute; override;
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure CheckNeeded;
  end;

  TRunInMainThreadHelper = class
    FProc: TMainThreadProc;
    FData: Pointer;
    procedure Execute;
  end;

var
  JobPool: TJobPool;
  _CPUCount: Integer;
{$IFDEF MSWINDOWS}
  GetTickCount64: TGetTickCount64;
  WinGetSystemTimes: TGetSystemTimes;
  _PerfFreq: Int64;
  _StartCounter: Int64;
{$ELSE}
  _Watch: TStopWatch;
{$ENDIF}
{$IFDEF __BORLANDC}
procedure FreeAsCDelete(AData: Pointer); external;
procedure FreeAsCDeleteArray(AData: Pointer); external;
{$ENDIF}

procedure ThreadYield;
begin
{$IFDEF MSWINDOWS}
  SwitchToThread;
{$ELSE}
  TThread.Yield;
{$ENDIF}
end;

function ThreadExists(AThreadId: TThreadId; AProcessId: DWORD): Boolean;
{$IFDEF MSWINDOWS}
  function WinThreadExists: Boolean;
  var
    ASnapshot: THandle;
    AEntry: TThreadEntry32;
  begin
    Result := False;
    ASnapshot := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if ASnapshot = INVALID_HANDLE_VALUE then
      Exit;
    try
      AEntry.dwSize := SizeOf(TThreadEntry32);
      if Thread32First(ASnapshot, AEntry) then
      begin
        if AProcessId = 0 then
          AProcessId := GetCurrentProcessId;
        repeat
          if ((AEntry.th32OwnerProcessID = AProcessId) or
            (AProcessId = $FFFFFFFF)) and (AEntry.th32ThreadID = AThreadId) then
          begin
            Result := True;
            Break;
          end;
        until not Thread32Next(ASnapshot, AEntry);
      end;
    finally
      CloseHandle(ASnapshot);
    end;
  end;
{$ENDIF}
{$IFDEF POSIX}
// Linux�Ľ��������߳�֮��Ĺ�ϵ������/proc/����ID/taskĿ¼�£�ÿһ��Ϊһ���߳�
  function IsChildThread: Boolean;
  var
    sr: TSearchRec;
    AId: Integer;
  begin
    Result := False;
    if FindFirst('/proc/' + IntToStr(AProcessId) + '/task/*', faAnyFile, sr) = 0
    then
    begin
      try
        repeat
          if TryStrToInt(sr.Name, AId) then
          begin
            if TThreadId(AId) = AThreadId then
              Result := True;
          end;
        until FindNext(sr) <> 0;
      finally
        FindClose(sr);
      end;
    end;
  end;
{$ENDIF}

begin
{$IFDEF POSIX}
  Result := pthread_kill(pthread_t(AThreadId), 0) = 0;
  if Result and (AProcessId <> $FFFFFFFF) then
  begin
    /// Ŀǰδ�ҵ����ʵķ����õ��������߳�ID��pthread_self�õ�����һ��ָ��
    { if AProcessId = 0 then
      AProcessId := getpid;
      Result :=IsChildThread; }
  end;
{$ELSE}
  Result := WinThreadExists;
{$ENDIF}
end;

procedure ProcessAppMessage;
{$IFDEF MSWINDOWS}
var
  AMsg: MSG;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  while PeekMessage(AMsg, 0, 0, 0, PM_REMOVE) do
  begin
    TranslateMessage(AMsg);
    DispatchMessage(AMsg);
  end;
{$ELSE}
  Application.ProcessMessages;
{$ENDIF}
end;

function MsgWaitForEvent(AEvent: TEvent; ATimeout: Cardinal): TWaitResult;
var
  T: Cardinal;
{$IFDEF MSWINDOWS}
  AHandles: array [0 .. 0] of THandle;
  rc: DWORD;
{$ENDIF}
begin
  if GetCurrentThreadId <> MainThreadId then
    Result := AEvent.WaitFor(ATimeout)
  else
  begin
{$IFDEF MSWINDOWS}
    Result := wrTimeout;
    AHandles[0] := AEvent.Handle;
    repeat
      T := GetTickCount;
      rc := MsgWaitForMultipleObjects(1, AHandles[0], False, ATimeout,
        QS_ALLINPUT);
      if rc = WAIT_OBJECT_0 + 1 then
      begin
        ProcessAppMessage;
        T := GetTickCount - T;
        if ATimeout > T then
          Dec(ATimeout, T)
        else
        begin
          Result := wrTimeout;
          Break;
        end;
      end
      else
      begin
        case rc of
          WAIT_ABANDONED:
            Result := wrAbandoned;
          WAIT_OBJECT_0:
            Result := wrSignaled;
          WAIT_TIMEOUT:
            Result := wrTimeout;
          WAIT_FAILED:
            Result := wrError;
          WAIT_IO_COMPLETION:
            Result := wrIOCompletion;
        end;
        Break;
      end;
    until False;
{$ELSE}
    repeat
      // ÿ��10������һ���Ƿ�����Ϣ��Ҫ�����������������������һ���ȴ�
      T := GetTimestamp;
      ProcessAppMessage;
      Result := AEvent.WaitFor(10);
      if Result = wrTimeout then
      begin
        T := (GetTimestamp - T) div 10;
        if ATimeout > T then
          Dec(ATimeout, T)
        else
          Break;
      end
      else
        Break;
    until False;
{$ENDIF}
  end;
end;

procedure ClearJobState(var AState: TQJobState);
begin
{$IFDEF UNICODE}
  if (AState.Flags and JOB_ANONPROC) <> 0 then
    TQJobProcA(AState.Proc.ProcA) := nil;
{$ENDIF}
  if IsFMXApp then
  begin
    AState.Proc.Code := nil;
    AState.Proc.Data := nil;
  end;
end;

function IsObjectJob(AJob: PQJob; AData: Pointer): Boolean;
begin
  Result := (AJob.WorkerProc.Data = AData) or
    (AJob.IsGrouped and (AJob.Group = AData));
end;

procedure ClearJobStates(var AStates: TQJobStateArray);
var
  I: Integer;
begin
  for I := 0 to High(AStates) do
    ClearJobState(AStates[I]);
  SetLength(AStates, 0);
end;

procedure JobInitialize(AJob: PQJob; AData: Pointer;
  AFreeType: TQJobDataFreeType; ARunOnce, ARunInMainThread: Boolean); inline;
begin
  AJob.Data := AData;
  if AData <> nil then
  begin
    AJob.Flags := AJob.Flags or (Integer(AFreeType) shl 8);
    if AFreeType = jdfFreeAsInterface then
      IUnknown(AData)._AddRef
{$IFDEF NEXTGEN}
      // �ƶ�ƽ̨��AData�ļ�����Ҫ���ӣ��Ա����Զ��ͷ�
    else if AFreeType = jdfFreeAsObject then
      TObject(AData).__ObjAddRef;
{$ENDIF}
    ;
  end;
  AJob.SetFlags(JOB_RUN_ONCE, ARunOnce);
  AJob.SetFlags(JOB_IN_MAINTHREAD, ARunInMainThread);
end;

// λ�룬����ԭֵ
function AtomicAnd(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result and AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

// λ�򣬷���ԭֵ
function AtomicOr(var Dest: Integer; const AMask: Integer): Integer; inline;
var
  I: Integer;
begin
  repeat
    Result := Dest;
    I := Result or AMask;
  until AtomicCmpExchange(Dest, I, Result) = Result;
end;

procedure SetThreadCPU(AHandle: THandle; ACpuNo: Integer);
begin
{$IFDEF MSWINDOWS}
  SetThreadIdealProcessor(AHandle, ACpuNo);
{$ELSE}
  // Linux/Andriod/iOS��ʱ����,XE6δ����sched_setaffinity����,ɶʱ�������ټ���֧��
{$ENDIF}
end;

// ����ֵ��ʱ�侫��Ϊ100ns����0.1ms
function GetTimestamp: Int64;
begin
{$IFDEF MSWINDOWS}
  if _PerfFreq > 0 then
  begin
    QueryPerformanceCounter(Result);
    Result := Trunc((Result - _StartCounter) / _PerfFreq * 10000);
  end
  else if Assigned(GetTickCount64) then
    Result := (GetTickCount64 - _StartCounter) * 10
  else
    Result := (GetTickCount - _StartCounter) * 10;
{$ELSE}
  Result := _Watch.Elapsed.Ticks div 1000;
{$ENDIF}
end;

function GetCPUCount: Integer;
{$IFDEF MSWINDOWS}
var
  si: SYSTEM_INFO;
{$ENDIF}
begin
  if _CPUCount = 0 then
  begin
{$IFDEF MSWINDOWS}
    GetSystemInfo(si);
    Result := si.dwNumberOfProcessors;
{$ELSE}// Linux,MacOS,iOS,Andriod{POSIX}
{$IFDEF POSIX}
{$WARN SYMBOL_PLATFORM OFF}
    Result := sysconf(_SC_NPROCESSORS_ONLN);
{$WARN SYMBOL_PLATFORM ON}
{$ELSE}// ����ʶ�Ĳ���ϵͳ��CPU��Ĭ��Ϊ1
    Result := 1;
{$ENDIF !POSIX}
{$ENDIF !MSWINDOWS}
  end
  else
    Result := _CPUCount;
end;

function MakeJobProc(const AProc: TQJobProcG): TQJobProc;
begin
  TMethod(Result).Data := nil;
  TMethod(Result).Code := @AProc;
end;

function SameWorkerProc(const P1: TQJobMethod; P2: TQJobProc): Boolean; inline;
begin
  Result := (P1.Code = TMethod(P2).Code) and (P1.Data = TMethod(P2).Data);
end;
{ TQJob }

procedure TQJob.AfterRun(AUsedTime: Int64);
begin
  Inc(Runs);
  if AUsedTime > 0 then
  begin
    Inc(TotalUsedTime, AUsedTime);
    if MinUsedTime = 0 then
      MinUsedTime := AUsedTime
    else if MinUsedTime > AUsedTime then
      MinUsedTime := AUsedTime;
    if MaxUsedTime = 0 then
      MaxUsedTime := AUsedTime
    else if MaxUsedTime < AUsedTime then
      MaxUsedTime := AUsedTime;
  end;
end;

procedure TQJob.Assign(const ASource: PQJob);
begin
  Self := ASource^;
{$IFDEF UNICODE}
  if IsAnonWorkerProc then
  begin
    WorkerProc.ProcA := nil;
    TQJobProcA(WorkerProc.ProcA) := TQJobProcA(ASource.WorkerProc.ProcA);
  end;
{$ENDIF}
  // ����������Ա������
  Worker := nil;
  Next := nil;
  Source := nil;
end;

constructor TQJob.Create(AProc: TQJobProc);
begin
{$IFDEF NEXTGEN}
  PQJobProc(@WorkerProc)^ := AProc;
{$ELSE}
  WorkerProc.Proc := AProc;
{$ENDIF}
  SetFlags(JOB_RUN_ONCE, True);
end;

function TQJob.GetAvgTime: Integer;
begin
  if Runs > 0 then
    Result := TotalUsedTime div Cardinal(Runs)
  else
    Result := 0;
end;

function TQJob.GetIsCustomFree: Boolean;
begin
  Result := FreeType in [jdfFreeAsC1 .. jdfFreeAsC6];
end;

function TQJob.GetIsInterfaceOwner: Boolean;
begin
  Result := (FreeType = jdfFreeAsInterface);
end;

function TQJob.GetIsObjectOwner: Boolean;
begin
  Result := (FreeType = jdfFreeAsObject);
end;

function TQJob.GetIsRecordOwner: Boolean;
begin
  Result := (FreeType = jdfFreeAsSimpleRecord);
end;

function TQJob.GetIsTerminated: Boolean;
begin
  if Assigned(Worker) then
    Result := Workers.Terminating or Worker.Terminated or
      ((Flags and JOB_TERMINATED) <> 0) or (Worker.FTerminatingJob = @Self)
  else
    Result := (Flags and JOB_TERMINATED) <> 0;
end;

function TQJob.GetElapsedTime: Int64;
begin
  Result := GetTimestamp - StartTime;
end;

function TQJob.GetExtData: TQJobExtData;
begin
  Result := Data;
end;

function TQJob.GetFlags(AIndex: Integer): Boolean;
begin
  Result := (Flags and AIndex) <> 0;
end;

function TQJob.GetFreeType: TQJobDataFreeType;
begin
  Result := TQJobDataFreeType((Flags shr 8) and $0F);
end;

function TQJob.GetHandle: IntPtr;
var
  AMask: IntPtr;
begin
  if IsSignalWakeup then
    AMask := JOB_HANDLE_SIGNAL_MASK
  else if IsByPlan then
    AMask := JOB_HANDLE_PLAN_MASK
  else if (FirstDelay <> 0) or (not Runonce) then
    AMask := JOB_HANDLE_REPEAT_MASK
  else
    AMask := JOB_HANDLE_SIMPLE_MASK;
  if Assigned(Source) then
    Result := IntPtr(Source) or AMask
  else
    Result := IntPtr(@Self) or AMask;
end;

procedure TQJob.Reset;
begin
  FillChar(Self, SizeOf(TQJob), 0);
end;

procedure TQJob.SetFlags(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    Flags := (Flags or AIndex)
  else
    Flags := (Flags and (not AIndex));
end;

procedure TQJob.SetFreeType(const Value: TQJobDataFreeType);
begin
  Flags := (Flags and (not JOB_DATA_OWNER)) or (Integer(Value) shl 8);
end;

procedure TQJob.SetIsTerminated(const Value: Boolean);
begin
  SetFlags(JOB_TERMINATED, Value);
end;
{$IFDEF UNICODE}

procedure TQJob.Synchronize(AProc: TThreadProcedure);
begin
  if GetCurrentThreadId = MainThreadId then
    AProc
  else
    Worker.Synchronize(AProc);
end;
{$ENDIF}

procedure TQJob.Synchronize(AMethod: TThreadMethod);
begin
  if GetCurrentThreadId = MainThreadId then
    AMethod
  else
    Worker.Synchronize(AMethod);
end;

procedure TQJob.UpdateNextTime;
begin
  if (Runs = 0) and (FirstDelay <> 0) then
    NextTime := PushTime + FirstDelay
  else if Interval <> 0 then
  begin
    if NextTime = 0 then
      NextTime := GetTimestamp + Interval
    else
      Inc(NextTime, Interval);
  end
  else
    NextTime := GetTimestamp;
end;

{ TQSimpleJobs }

function TQSimpleJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  // �Ƚ�SimpleJobs���е��첽��ҵ��գ��Է�ֹ������ִ��
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
    ANext := AJob.Next;
    if IsObjectJob(AJob, AObject) then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Dec(AMaxTimes);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

function TQSimpleJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  while (AJob <> nil) and (AMaxTimes <> 0) do
  begin
    ANext := AJob.Next;
    if SameWorkerProc(AJob.WorkerProc, AProc) and
      ((AJob.Data = AData) or (AData = INVALID_JOB_DATA)) then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Dec(AMaxTimes);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

procedure TQSimpleJobs.Clear;
var
  AFirst: PQJob;
begin
  FLocker.Enter;
  AFirst := FFirst;
  FFirst := nil;
  FLast := nil;
  FCount := 0;
  FLocker.Leave;
  FOwner.FreeJob(AFirst);
end;

function TQSimpleJobs.Clear(AHandle: IntPtr): Boolean;
var
  AFirst, AJob, APrior, ANext: PQJob;
begin
  AJob := PopAll;
  Result := False;
  APrior := nil;
  AFirst := nil;
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if Int64(AJob) = AHandle then
    begin
      if APrior <> nil then
        APrior.Next := ANext
      else // �׸�
        AFirst := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Result := True;
      Break;
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

constructor TQSimpleJobs.Create(AOwner: TQWorkers);
begin
  inherited Create(AOwner);
  FLocker := TQSimpleLock.Create;
end;

destructor TQSimpleJobs.Destroy;
begin
  inherited;
  FreeObject(FLocker);
end;

function TQSimpleJobs.GetCount: Integer;
begin
  Result := FCount;
end;

function TQSimpleJobs.InternalPop: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  if Result <> nil then
  begin
    FFirst := Result.Next;
    if FFirst = nil then
      FLast := nil;
    Dec(FCount);
  end;
  FLocker.Leave;
end;

function TQSimpleJobs.InternalPush(AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  if FLast = nil then
    FFirst := AJob
  else
    FLast.Next := AJob;
  FLast := AJob;
  Inc(FCount);
  FLocker.Leave;
  Result := True;
end;

function TQSimpleJobs.PopAll: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  FFirst := nil;
  FLast := nil;
  FCount := 0;
  FLocker.Leave;
end;

procedure TQSimpleJobs.Repush(ANewFirst: PQJob);
var
  ALast: PQJob;
  ACount: Integer;
begin
  if ANewFirst <> nil then
  begin
    ALast := ANewFirst;
    ACount := 0;
    while ALast.Next <> nil do
    begin
      ALast := ALast.Next;
      Inc(ACount);
    end;
    FLocker.Enter;
    ALast.Next := FFirst;
    FFirst := ANewFirst;
    if FLast = nil then
      FLast := ALast;
    Inc(FCount, ACount);
    FLocker.Leave;
  end;
end;

function TQSimpleJobs.ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
var
  AFirst, AJob, APrior, ANext: PQJob;
  // AHandleEof: PIntPtr;
  function Accept(AJob: PQJob): Boolean;
  var
    p: PIntPtr;
  begin
    p := AHandles;
    Result := False;
    while IntPtr(p) < IntPtr(AHandles) do
    begin
      if (IntPtr(p^) and (not $03)) = IntPtr(AJob) then
      begin
        p^ := 0; // �ÿ�
        Result := True;
        Exit;
      end;
      Inc(p);
    end;
  end;

begin
  AJob := PopAll;
  Result := 0;
  APrior := nil;
  AFirst := nil;
  // AHandleEof := AHandles;
  // Inc(AHandleEof, ACount);
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if Accept(AJob) then
    begin
      if APrior <> nil then
        APrior.Next := ANext;
      AJob.Next := nil;
      FOwner.FreeJob(AJob);
      Inc(Result);
      Break;
    end
    else
    begin
      if AFirst = nil then
        AFirst := AJob;
      APrior := AJob;
    end;
    AJob := ANext;
  end;
  Repush(AFirst);
end;

{ TQJobs }

procedure TQJobs.Clear;
var
  AItem: PQJob;
begin
  repeat
    AItem := Pop;
    if AItem <> nil then
      FOwner.FreeJob(AItem)
    else
      Break;
  until 1 > 2;
end;

function TQJobs.Clear(AHandle: IntPtr): Boolean;
begin
  Result := ClearJobs(@AHandle, 1) = 1;
end;

constructor TQJobs.Create(AOwner: TQWorkers);
begin
  inherited Create;
  FOwner := AOwner;
  CoInitializeEx(nil, COINIT_MULTITHREADED);
end;

destructor TQJobs.Destroy;
begin
  Clear;
  inherited;
end;

function TQJobs.GetEmpty: Boolean;
begin
  Result := (Count = 0);
end;

function TQJobs.Pop: PQJob;
begin
  Result := InternalPop;
  if Result <> nil then
  begin
    Result.PopTime := GetTimestamp;
    Result.Next := nil;
  end;
end;

function TQJobs.Push(AJob: PQJob): Boolean;
begin
  // Assert(AJob.WorkerProc.Code<>nil);
  AJob.Owner := Self;
  AJob.PushTime := GetTimestamp;
  Result := InternalPush(AJob);
  if not Result then
  begin
    AJob.Next := nil;
    FOwner.FreeJob(AJob);
  end;
end;

{ TQRepeatJobs }

procedure TQRepeatJobs.Clear;
begin
  FLocker.Enter;
  try
    FItems.Clear;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
begin
  // ��������ظ��ļƻ���ҵ
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := True;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if IsObjectJob(AJob, AObject) then
        begin
          if ANode.Data = AJob then
            ANode.Data := AJob.Next;
          if Assigned(APriorJob) then
            APriorJob.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Dec(AMaxTimes);
          Inc(Result);
        end
        else
        begin
          ACanDelete := False;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

procedure TQRepeatJobs.AfterJobRun(AJob: PQJob; AUsedTime: Int64);
var
  ANode: TQRBNode;
  function UpdateSource: Boolean;
  var
    ATemp, APrior: PQJob;
  begin
    Result := False;
    ATemp := ANode.Data;
    APrior := nil;
    while ATemp <> nil do
    begin
      if ATemp = AJob.Source then
      begin
        if AJob.IsTerminated then
        begin
          if APrior <> nil then
            APrior.Next := ATemp.Next
          else
            ANode.Data := ATemp.Next;
          ATemp.Next := nil;
          FOwner.FreeJob(ATemp);
          if ANode.Data = nil then
            FItems.Delete(ANode);
        end
        else
          ATemp.AfterRun(AUsedTime);
        Result := True;
        Break;
      end;
      APrior := ATemp;
      ATemp := ATemp.Next;
    end;
  end;

begin
  FLocker.Enter;
  try
    ANode := FItems.Find(AJob);
    if ANode <> nil then
    begin
      if UpdateSource then
        Exit;
    end;
    ANode := FItems.First;
    while ANode <> nil do
    begin
      if UpdateSource then
        Break;
      ANode := ANode.Next;
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  AJob, APrior, ANext: PQJob;
  ANode, ANextNode: TQRBNode;
begin
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while (ANode <> nil) and (AMaxTimes <> 0) do
    begin
      AJob := ANode.Data;
      APrior := nil;
      repeat
        if SameWorkerProc(AJob.WorkerProc, AProc) and
          ((AData = INVALID_JOB_DATA) or (AData = AJob.Data)) then
        begin
          ANext := AJob.Next;
          if APrior = nil then
            ANode.Data := ANext
          else
            APrior.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          AJob := ANext;
          Dec(AMaxTimes);
          Inc(Result);
        end
        else
        begin
          APrior := AJob;
          AJob := AJob.Next
        end;
      until AJob = nil;
      if ANode.Data = nil then
      begin
        ANextNode := ANode.Next;
        FItems.Delete(ANode);
        ANode := ANextNode;
      end
      else
        ANode := ANode.Next;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

constructor TQRepeatJobs.Create(AOwner: TQWorkers);
begin
  inherited;
  FItems := TQRBTree.Create(DoTimeCompare);
  FItems.OnDelete := DoJobDelete;
  FLocker := TCriticalSection.Create;
end;

destructor TQRepeatJobs.Destroy;
begin
  inherited;
  FreeObject(FItems);
  FreeObject(FLocker);
end;

procedure TQRepeatJobs.DoJobDelete(ATree: TQRBTree; ANode: TQRBNode);
begin
  FOwner.FreeJob(ANode.Data);
end;

function TQRepeatJobs.DoTimeCompare(P1, P2: Pointer): Integer;
var
  ATemp: Int64;
begin
  ATemp := PQJob(P1).NextTime - PQJob(P2).NextTime;
  if ATemp < 0 then
    Result := -1
  else if ATemp > 0 then
    Result := 1
  else
    Result := 0;
end;

function TQRepeatJobs.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQRepeatJobs.InternalPop: PQJob;
var
  ANode: TQRBNode;
  ATick: Int64;
  AJob: PQJob;
begin
  Result := nil;
  if FItems.Count = 0 then
    Exit;
  FLocker.Enter;
  try
    if FItems.Count > 0 then
    begin
      ATick := GetTimestamp;
      ANode := FItems.First;
      AJob := ANode.Data;
      // OutputDebugString(PWideChar('Result.NextTime='+IntToStr(AJob.NextTime)+',Current='+IntToStr(ATick)+',Delta='+IntToStr(AJob.NextTime-ATick)));
      if AJob.NextTime <= ATick then
      begin
        if AJob.Next <> nil then
          // ���û�и�����Ҫִ�е���ҵ����ɾ����㣬����ָ����һ��
          ANode.Data := AJob.Next
        else
        begin
          ANode.Data := nil;
          FItems.Delete(ANode);
          ANode := FItems.First;
          if ANode <> nil then
            FFirstFireTime := PQJob(ANode.Data).NextTime
          else
            // û�мƻ���ҵ�ˣ�����Ҫ��
            FFirstFireTime := 0;
        end;
        if AJob.Runonce then
          Result := AJob
        else
        begin
          AJob.Next := nil;
          AJob.PopTime := ATick;
          Inc(AJob.NextTime, AJob.Interval);
          Result := JobPool.Pop;
          Result.Assign(AJob);
          Result.Source := AJob;
          // ���²�����ҵ
          ANode := FItems.Find(AJob);
          if ANode = nil then
          begin
            FItems.Insert(AJob);
            FFirstFireTime := PQJob(FItems.First.Data).NextTime;
          end
          else
          // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ��
          begin
            AJob.Next := PQJob(ANode.Data);
            ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
          end;
        end;
      end;
    end
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.InternalPush(AJob: PQJob): Boolean;
var
  ANode: TQRBNode;
begin
  // ������ҵ���´�ִ��ʱ��
  AJob.UpdateNextTime;
  FLocker.Enter;
  try
    ANode := FItems.Find(AJob);
    if ANode = nil then
    begin
      FItems.Insert(AJob);
      FFirstFireTime := PQJob(FItems.First.Data).NextTime;
    end
    else
    // ����Ѿ�����ͬһʱ�̵���ҵ�����Լ��ҽӵ�������ҵͷ��
    begin
      AJob.Next := PQJob(ANode.Data);
      ANode.Data := AJob; // �׸���ҵ��Ϊ�Լ�
    end;
    Result := True;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.Clear(AHandle: IntPtr): Boolean;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
begin
  Result := False;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while ANode <> nil do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := True;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if Int64(AJob) = AHandle then
        begin
          if ANode.Data = AJob then
            ANode.Data := AJob.Next;
          if Assigned(APriorJob) then
            APriorJob.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Result := True;
          Break;
        end
        else
        begin
          ACanDelete := False;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

function TQRepeatJobs.ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
var
  ANode, ANext: TQRBNode;
  APriorJob, AJob, ANextJob: PQJob;
  ACanDelete: Boolean;
  function Accept(AJob: PQJob): Boolean;
  var
    p: PIntPtr;
  begin
    p := AHandles;
    Result := False;
    while IntPtr(p) < IntPtr(AHandles) do
    begin
      if (IntPtr(p^) and (not $03)) = IntPtr(AJob) then
      begin
        p^ := 0;
        Result := True;
        Exit;
      end;
      Inc(p);
    end;
  end;

begin
  Result := 0;
  FLocker.Enter;
  try
    ANode := FItems.First;
    while ANode <> nil do
    begin
      ANext := ANode.Next;
      AJob := ANode.Data;
      ACanDelete := True;
      APriorJob := nil;
      while AJob <> nil do
      begin
        ANextJob := AJob.Next;
        if Accept(AJob) then
        begin
          if ANode.Data = AJob then
            ANode.Data := AJob.Next;
          if Assigned(APriorJob) then
            APriorJob.Next := AJob.Next;
          AJob.Next := nil;
          FOwner.FreeJob(AJob);
          Inc(Result);
        end
        else
        begin
          ACanDelete := False;
          APriorJob := AJob;
        end;
        AJob := ANextJob;
      end;
      if ACanDelete then
        FItems.Delete(ANode);
      ANode := ANext;
    end;
    if FItems.Count > 0 then
      FFirstFireTime := PQJob(FItems.First.Data).NextTime
    else
      FFirstFireTime := 0;
  finally
    FLocker.Leave;
  end;
end;

{ TQWorker }

procedure TQWorker.ComNeeded(AInitFlags: Cardinal);
begin
{$IFDEF MSWINDOWS}
  if not ComInitialized then
  begin
    if AInitFlags = 0 then
      CoInitialize(nil)
    else
      CoInitializeEx(nil, AInitFlags);
    FFlags := FFlags or WORKER_COM_INITED;
  end;
{$ENDIF MSWINDOWS}
end;

constructor TQWorker.Create(AOwner: TQWorkers);
begin
  inherited Create(True);
  FOwner := AOwner;
  FTimeout := 1000;
  FreeOnTerminate := True;
  FEvent := TEvent.Create(nil, False, False, '');
end;

destructor TQWorker.Destroy;
begin
  FreeObject(FEvent);
  inherited;
end;

procedure TQWorker.DoJob(AJob: PQJob);
begin
{$IFDEF UNICODE}
  if AJob.IsAnonWorkerProc then
    TQJobProcA(AJob.WorkerProc.ProcA)(AJob)
  else
{$ENDIF}
  begin
    if AJob.WorkerProc.Data <> nil then
{$IFDEF NEXTGEN}
      PQJobProc(@AJob.WorkerProc)^(AJob)
{$ELSE}
      AJob.WorkerProc.Proc(AJob)
{$ENDIF}
    else
      AJob.WorkerProc.ProcG(AJob);
  end;
end;

function TQWorker.WaitSignal(ATimeout: Integer; AByRepeatJob: Boolean)
  : TWaitResult;
var
  T: Int64;
begin
  if ATimeout > 1 then
  begin
    T := GetTimestamp;
    if Cardinal(ATimeout) > FOwner.FFireTimeout + FFireDelay - FTimeout then
      ATimeout := FOwner.FFireTimeout + FFireDelay - FTimeout;
    Result := FEvent.WaitFor(ATimeout);
    T := GetTimestamp - T;
    if Result = wrTimeout then
    begin
      Inc(FTimeout, T div 10);
      if AByRepeatJob then
        Result := wrSignaled;
    end;
  end
  else
    Result := wrSignaled;
end;

procedure TQWorker.Execute;
var
  wr: TWaitResult;
{$IFDEF MSWINDOWS}
  SyncEvent: TEvent;
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  SyncEvent := TEvent.Create(nil, False, False, '');
{$IF RTLVersion>=21}
  NameThreadForDebugging('QWorker');
{$IFEND >=2010}
{$ENDIF}
  try
    SetFlags(WORKER_RUNNING, True);
    FLastActiveTime := GetTimestamp;
    FFireDelay := Random(FOwner.FFireTimeout shr 1);
    while not(Terminated or FOwner.FTerminating) do
    begin
      SetFlags(WORKER_CLEANING, False);
      if FOwner.Enabled then
      begin
        if FOwner.FSimpleJobs.FFirst <> nil then
          wr := WaitSignal(0, False)
        else if (FOwner.FRepeatJobs.FFirstFireTime <> 0) then
          wr := WaitSignal((FOwner.FRepeatJobs.FFirstFireTime - GetTimestamp)
            div 10, True)
        else
          wr := WaitSignal(FOwner.FFireTimeout, False);
      end
      else
        wr := WaitSignal(FOwner.FFireTimeout, False);
      if Terminated or FOwner.FTerminating then
        Break;
      if wr = wrSignaled then
      begin
        if FOwner.FTerminating then
          Break;

        FPending := False;
        if (FOwner.Workers - AtomicIncrement(FOwner.FBusyCount) = 0) and
          (FOwner.Workers < FOwner.MaxWorkers) then
          FOwner.NewWorkerNeeded;
        repeat
          SetFlags(WORKER_LOOKUP, True);
          FActiveJob := FOwner.Popup;
          SetFlags(WORKER_LOOKUP, False);
          if FActiveJob <> nil then
          begin
            SetFlags(WORKER_ISBUSY, True);
            FTimeout := 0;
            FLastActiveTime := FActiveJob.PopTime;
            FActiveJob.Worker := Self;
            FActiveJobProc := FActiveJob.WorkerProc;
            // {$IFDEF NEXTGEN} PQJobProc(@FActiveJob.WorkerProc)^
            // {$ELSE} FActiveJob.WorkerProc.Proc {$ENDIF};
            // ΪClear(AObject)׼���жϣ��Ա���FActiveJob�̲߳���ȫ
            FActiveJobData := FActiveJob.Data;
            if FActiveJob.IsSignalWakeup then
              FActiveJobSource := FActiveJob.Source
            else
              FActiveJobSource := nil;
            if FActiveJob.IsGrouped then
              FActiveJobGroup := FActiveJob.Group
            else
              FActiveJobGroup := nil;
            FActiveJobFlags := FActiveJob.Flags;
            if FActiveJob.StartTime = 0 then
            begin
              FActiveJob.StartTime := FLastActiveTime;
              FActiveJob.FirstStartTime := FActiveJob.StartTime;
            end
            else
              FActiveJob.StartTime := FLastActiveTime;
            try
              FFlags := (FFlags or WORKER_EXECUTING) and (not WORKER_LOOKUP);
              if FActiveJob.InMainThread then
{$IFDEF MSWINDOWS}
              begin
                if PostMessage(FOwner.FMainWorker, WM_APP, WPARAM(FActiveJob),
                  LPARAM(SyncEvent)) then
                  SyncEvent.WaitFor(INFINITE);
              end
{$ELSE}
              Synchronize(Self, FireInMainThread)
{$ENDIF}
              else
                DoJob(FActiveJob);
            except
              on E: Exception do
                if Assigned(FOwner.FOnError) then
                  FOwner.FOnError(FActiveJob, E, jesExecute);
            end;

            Inc(FProcessed);
            SetFlags(WORKER_CLEANING, True);
            FActiveJob.Worker := nil;
            if not FActiveJob.Runonce then
            begin
              if FActiveJob.IsByPlan then
                FOwner.AfterPlanRun(FActiveJob,
                  GetTimestamp - FActiveJob.StartTime)
              else
                FOwner.FRepeatJobs.AfterJobRun(FActiveJob,
                  GetTimestamp - FActiveJob.StartTime);
              FActiveJob.Data := nil;
            end
            else
            begin
              if FActiveJob.IsSignalWakeup then
                FOwner.SignalWorkDone(FActiveJob,
                  GetTimestamp - FActiveJob.StartTime)
              else if FActiveJob.IsLongtimeJob then
                AtomicDecrement(FOwner.FLongTimeWorkers)
              else if FActiveJob.IsGrouped then
                FActiveJobGroup.DoJobExecuted(FActiveJob)
              else if FActiveJob.IsDelayRepeat then
              begin
                if not FActiveJob.IsTerminated then
                begin
                  FActiveJob.DoneTime := GetTimestamp;
                  FOwner.Post(FActiveJob);
                  FActiveJob := nil;
                end;
              end;
            end;
            if Assigned(FActiveJob) then
              FOwner.FreeJob(FActiveJob);
            FActiveJobProc.Code := nil;
            FActiveJobProc.Data := nil;
            FActiveJobSource := nil;
            FActiveJobFlags := 0;
            FActiveJobGroup := nil;
            FTerminatingJob := nil;
            FFlags := FFlags and (not WORKER_EXECUTING);
          end
          else
            FFlags := FFlags and (not WORKER_LOOKUP);
        until (FActiveJob = nil) or Terminated or FOwner.FTerminating or
          (not FOwner.Enabled);
        SetFlags(WORKER_ISBUSY, False);
        AtomicDecrement(FOwner.FBusyCount);
        // ThreadYield;
      end;
      if (FTimeout >= FOwner.FireTimeout + FFireDelay) then
      // ��һ�������2���ӳ٣��Ա���ͬʱ�ͷ�
      begin
        FOwner.WorkerTimeout(Self);
        if not IsFiring then
          FTimeout := 0;
      end;
    end;
  finally
    SetFlags(WORKER_RUNNING, False);
{$IFDEF MSWINDOWS}
    FreeObject(SyncEvent);
    if ComInitialized then
      CoUninitialize;
{$ENDIF}
    FOwner.WorkerTerminate(Self);
  end;
end;

procedure TQWorker.FireInMainThread;
begin
  DoJob(FActiveJob);
end;

function TQWorker.GetFlags(AIndex: Integer): Boolean;
begin
  Result := ((FFlags and AIndex) <> 0);
end;

function TQWorker.GetIsIdle: Boolean;
begin
  Result := not IsBusy;
end;

procedure TQWorker.SetFlags(AIndex: Integer; AValue: Boolean);
begin
  if AValue then
    FFlags := FFlags or AIndex
  else
    FFlags := FFlags and (not AIndex);
end;

{ TQWorkers }

function TQWorkers.Post(AJob: PQJob): IntPtr;
begin
  Result := 0;
  if (not FTerminating) and (Assigned(AJob.WorkerProc.Proc)
{$IFDEF UNICODE} or Assigned(AJob.WorkerProc.ProcA){$ENDIF}) then
  begin
    if AJob.Runonce and (AJob.FirstDelay = 0) then
    begin
      if FSimpleJobs.Push(AJob) then
      begin
        Result := IntPtr(AJob);
        LookupIdleWorker(True);
      end;
    end
    else if AJob.IsByPlan then
    begin
      Result := IntPtr(AJob) or JOB_HANDLE_PLAN_MASK;
      FPlanJobs.Push(AJob);
      PlanCheckNeeded;
    end
    else if FRepeatJobs.Push(AJob) then
    begin
      Result := IntPtr(AJob) or JOB_HANDLE_REPEAT_MASK;
      LookupIdleWorker(False);
    end;
  end
  else
  begin
    AJob.Next := nil;
    FreeJob(AJob);
  end;
end;

function TQWorkers.Post(AProc: TQJobProc; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin

  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, True, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProc; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  AJob.Interval := AInterval;
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Post(AProc: TQJobProcG; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Post(MakeJobProc(AProc), AData, ARunInMainThread, AFreeType);
end;

{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, True, ARunInMainThread);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  AJob.IsAnonWorkerProc := True;
  Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.Clear(AObject: Pointer; AMaxTimes: Integer): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
    Result := 0;
    FLocker.Enter;
    try
      for I := 0 to FSignalJobs.BucketCount - 1 do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            APrior := nil;
            while (AJob <> nil) and (AMaxTimes <> 0) do
            begin
              ANext := AJob.Next;
              if IsObjectJob(AJob, AObject) then
              begin
                if ASignal.First = AJob then
                  ASignal.First := ANext;
                if Assigned(APrior) then
                  APrior.Next := ANext;
                AJob.Next := nil;
                FreeJob(AJob);
                Dec(AMaxTimes);
                Inc(Result);
              end
              else
                APrior := AJob;
              AJob := ANext;
            end;
            if AMaxTimes = 0 then
              Break;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := 0;
  if Self <> nil then
  begin
    ACleared := FSimpleJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FRepeatJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := ClearSignalJobs;
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FPlanJobs.Clear(AObject, AMaxTimes);
    Inc(Result, ACleared);
    Dec(AMaxTimes, ACleared);
    if AMaxTimes = 0 then
      Exit;
    AWaitParam.WaitType := 0;
    AWaitParam.Bound := AObject;
    WaitRunningDone(AWaitParam);
  end;
end;

function TQWorkers.At(AProc: TQJobProc; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  AJob.Interval := AInterval;
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;

function TQWorkers.At(AProc: TQJobProc; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow, ATemp: TDateTime;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  AJob.Interval := AInterval;
  // ATime����ֻҪʱ�䲿�֣����ں���
  ANow := Now;
  ANow := ANow - Trunc(ANow);
  ATemp := ATime - Trunc(ATime);
  if ANow > ATemp then // �ðɣ�����ĵ��Ѿ����ˣ�������
    ADelay := Trunc(((1 - ANow) + ATemp) * Q1Day) // �ӳٵ�ʱ�䣬��λΪ0.1ms
  else
    ADelay := Trunc((ATemp - ANow) * Q1Day);
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProc; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcG; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;
{$IFDEF UNICODE}

class function TQWorkers.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcA; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
begin
  Result := TQForJobs.For(AStartIndex, AStopIndex, AWorkerProc, AMsgWait, AData,
    AFreeType);
end;

function TQWorkers.At(AProc: TQJobProcA; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
  ADelay: Int64;
  ANow, ATemp: TDateTime;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  AJob.IsAnonWorkerProc := True;
  AJob.Interval := AInterval;
  // ATime����ֻҪʱ�䲿�֣����ں���
  ANow := Now;
  ANow := ANow - Trunc(ANow);
  ATemp := ATime - Trunc(ATime);
  if ANow > ATemp then // �ðɣ�����ĵ��Ѿ����ˣ�������
    ADelay := Trunc(((1 + ANow) - ATemp) * Q1Day) // �ӳٵ�ʱ�䣬��λΪ0.1ms
  else
    ADelay := Trunc((ATemp - ANow) * Q1Day);
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;
{$ENDIF}

procedure TQWorkers.AfterPlanRun(AJob: PQJob; AUsedTime: Int64);
begin
  PQJob(AJob.PlanJob).AfterRun(AUsedTime);
end;

function TQWorkers.Clear(AProc: TQJobProc; AData: Pointer;
  AMaxTimes: Integer): Integer;
var
  ACleared: Integer;
  AWaitParam: TWorkerWaitParam;
  function ClearSignalJobs: Integer;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
    Result := 0;
    FLocker.Enter;
    try
      for I := 0 to FSignalJobs.BucketCount - 1 do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            APrior := nil;
            while (AJob <> nil) and (AMaxTimes <> 0) do
            begin
              ANext := AJob.Next;
              if SameWorkerProc(AJob.WorkerProc, AProc) and
                ((AData = Pointer(-1)) or (AJob.Data = AData)) then
              begin
                if ASignal.First = AJob then
                  ASignal.First := ANext;
                if Assigned(APrior) then
                  APrior.Next := ANext;
                AJob.Next := nil;
                FreeJob(AJob);
                Inc(Result);
                Dec(AMaxTimes);
              end
              else
                APrior := AJob;
              AJob := ANext;
            end;
            if AMaxTimes = 0 then
              Break;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := 0;
  if Self <> nil then
  begin
    ACleared := FSimpleJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FRepeatJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := ClearSignalJobs; // Don dec AMaxTimes in current line
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    ACleared := FPlanJobs.Clear(AProc, AData, AMaxTimes);
    Dec(AMaxTimes, ACleared);
    Inc(Result, ACleared);
    if AMaxTimes = 0 then
      Exit;
    AWaitParam.WaitType := 1;
    AWaitParam.Data := AData;
    AWaitParam.WorkerProc := TMethod(AProc);
    WaitRunningDone(AWaitParam);
  end;
end;

procedure TQWorkers.ClearWorkers;
var
  I: Integer;
  AInMainThread: Boolean;
  function WorkerExists: Boolean;
  var
    J: Integer;
  begin
    Result := False;
    FLocker.Enter;
    try
      J := FWorkerCount - 1;
      while J >= 0 do
      begin
        if ThreadExists(FWorkers[J].ThreadId) then
        begin
          Result := True;
          Break;
        end;
        Dec(J);
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  FTerminating := True;
  FLocker.Enter;
  try
    FRepeatJobs.FFirstFireTime := 0;
    for I := 0 to FWorkerCount - 1 do
      FWorkers[I].FEvent.SetEvent;
  finally
    FLocker.Leave;
  end;
  AInMainThread := GetCurrentThreadId = MainThreadId;
  while (FWorkerCount > 0) and WorkerExists do
  begin
    if AInMainThread then
      ProcessAppMessage;
    Sleep(10);
  end;
  for I := 0 to FWorkerCount - 1 do
  begin
    if FWorkers[I] <> nil then
      FreeObject(FWorkers[I]);
  end;
  FWorkerCount := 0;
end;

constructor TQWorkers.Create(AMinWorkers: Integer);
var
  ACpuCount: Integer;
  I: Integer;

begin
  FSimpleJobs := TQSimpleJobs.Create(Self);
  FPlanJobs := TQSimpleJobs.Create(Self);
  FRepeatJobs := TQRepeatJobs.Create(Self);
  FSignalJobs := TQHashTable.Create();
  FSignalJobs.OnDelete := DoJobFree;
  FSignalJobs.AutoSize := True;
  FFireTimeout := DEFAULT_FIRE_TIMEOUT;
  FStaticThread := TStaticThread.Create;
  ACpuCount := GetCPUCount;
  if AMinWorkers < 1 then
    FMinWorkers := 2
  else
    FMinWorkers := AMinWorkers;
  // ���ٹ�����Ϊ2��
  FMaxWorkers := (ACpuCount shl 1) + 1;
  if FMaxWorkers <= FMinWorkers then
    FMaxWorkers := (FMinWorkers shl 1) + 1;
  FLocker := TCriticalSection.Create;
  FTerminating := False;
  // ����Ĭ�Ϲ�����
  FWorkerCount := 0;
  SetLength(FWorkers, FMaxWorkers + 1);
  for I := 0 to FMinWorkers - 1 do
    FWorkers[I] := CreateWorker(True);
  for I := 0 to FMinWorkers - 1 do
  begin
    FWorkers[I].FEvent.SetEvent;
    FWorkers[I].Suspended := False;
  end;
  FMaxLongtimeWorkers := (FMaxWorkers shr 1);
{$IFDEF MSWINDOWS}
  FMainWorker := AllocateHWnd(DoMainThreadWork);
{$ENDIF}
  FStaticThread.Suspended := False;
end;

function TQWorkers.CreateWorker(ASuspended: Boolean): TQWorker;
begin
  if FWorkerCount < FMaxWorkers then
  begin
    Result := TQWorker.Create(Self);
    FWorkers[FWorkerCount] := Result;
{$IFDEF MSWINDOWS}
    SetThreadCPU(Result.Handle, FWorkerCount mod GetCPUCount);
{$ELSE}
    SetThreadCPU(Result.ThreadId, FWorkerCount mod GetCPUCount);
{$ENDIF}
    Inc(FWorkerCount);
    if not ASuspended then
    begin
      Result.FPending := True;
      Result.FEvent.SetEvent;
      Result.Suspended := False;
    end;
  end
  else
    Result := nil;
end;

function TQWorkers.Delay(AProc: TQJobProc; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, True, ARunInMainThread);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

{$IFDEF UNICODE}

function TQWorkers.Delay(AProc: TQJobProcA; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, True, ARunInMainThread);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  AJob.IsAnonWorkerProc := True;
  if ADelay > 0 then
    AJob.FirstDelay := ADelay;
  AJob.IsDelayRepeat := ARepeat;
  Result := Post(AJob);
end;

{$ENDIF}

function TQWorkers.Delay(AProc: TQJobProcG; ADelay: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType;
  ARepeat: Boolean): IntPtr;
begin
  Result := Delay(MakeJobProc(AProc), ADelay, AData, ARunInMainThread,
    AFreeType, ARepeat);
end;

destructor TQWorkers.Destroy;
var
  AStaticThreadId: TThreadId;
  AInMainThread: Boolean;
begin
  ClearWorkers;
  FLocker.Enter;
  try
    FreeObject(FSimpleJobs);
    FreeObject(FPlanJobs);
    FreeObject(FRepeatJobs);
    FreeObject(FSignalJobs);
  finally
    FreeObject(FLocker);
  end;
{$IFDEF MSWINDOWS}
  DeallocateHWnd(FMainWorker);
{$ENDIF}
  AStaticThreadId := FStaticThread.ThreadId;
  FStaticThread.FreeOnTerminate := True;
  FStaticThread.Terminate;
  ThreadYield;
  AInMainThread := GetCurrentThreadId = MainThreadId;
  while ThreadExists(AStaticThreadId) and Assigned(FStaticThread) do
  begin
    if AInMainThread then
      ProcessAppMessage;
    Sleep(200);
  end;
  inherited;
end;

procedure TQWorkers.DisableWorkers;
begin
  AtomicIncrement(FDisableCount);
end;

procedure TQWorkers.DoCustomFreeData(AFreeType: TQJobDataFreeType;
  const AData: Pointer);
begin
  if Assigned(FOnCustomFreeData) then
    FOnCustomFreeData(Self, AFreeType, AData);
end;

procedure TQWorkers.DoJobFree(ATable: TQHashTable; AHash: Cardinal;
  AData: Pointer);
var
  ASignal: PQSignal;
begin
  ASignal := AData;
  if ASignal.First <> nil then
    FreeJob(ASignal.First);
  Dispose(ASignal);
end;
{$IFDEF MSWINDOWS}

procedure TQWorkers.DoMainThreadWork(var AMsg: TMessage);
var
  AJob: PQJob;
begin
  if AMsg.MSG = WM_APP then
  begin
    AJob := PQJob(AMsg.WPARAM);
    try
      AJob.Worker.DoJob(AJob);
    except
      on E: Exception do
      begin
        if Assigned(FOnError) then
          FOnError(AJob, E, jesExecute);
      end;
    end;
    if AMsg.LPARAM <> 0 then
      TEvent(AMsg.LPARAM).SetEvent;
  end
  else
    AMsg.Result := DefWindowProc(FMainWorker, AMsg.MSG, AMsg.WPARAM,
      AMsg.LPARAM);
end;

{$ENDIF}

procedure TQWorkers.DoPlanCheck(AJob: PQJob);
var
  AItem, ATimeoutJob, APrior, ANext: PQJob;
  ATime: TDateTime;
  Y, M, D, H, N, S, MS: Word;
  AStamp: Int64;
  APlan: PQJobPlanData;
begin
  ATime := Now;
  DecodeDate(ATime, Y, M, D);
  DecodeTime(ATime, H, N, S, MS);
  AStamp := GetTimestamp;
  ATimeoutJob := nil;
  APrior := nil;
  FPlanJobs.FLocker.Enter;
  try
    AItem := FPlanJobs.FFirst;
    while Assigned(AItem) do
    begin
      APlan := AItem.ExtData.AsPlan;
      case APlan.Plan.Timeout(ATime) of
        pcrOk:
          begin
            AJob := JobPool.Pop;
            AJob.Assign(AItem);
            AJob.Source := AItem;
            AJob.Data := AItem.ExtData.AsPlan.OriginData;
            AJob.IsByPlan := True;
            AJob.FreeType := jdfFreeByUser;
            AJob.PlanJob := AItem;
            AItem.PopTime := AStamp;
            if not FSimpleJobs.Push(AJob) then
            begin
              JobPool.Push(AJob);
              Break;
            end;
          end;
        pcrTimeout:
          begin
            ANext := AItem.Next;
            if AItem = FPlanJobs.FFirst then
              FPlanJobs.FFirst := ANext;
            if AItem = FPlanJobs.FLast then
              FPlanJobs.FLast := APrior;
            AItem.Next := ATimeoutJob;
            ATimeoutJob := AItem;
            if Assigned(APrior) then
              APrior.Next := ANext;
            AItem := ANext;
            Continue;
          end;
      end;
      APrior := AItem;
      AItem := AItem.Next;
    end;
  finally
    FPlanJobs.FLocker.Leave;
    if Assigned(ATimeoutJob) then
      FreeJob(ATimeoutJob);
  end;
end;

procedure TQWorkers.EnableWorkers;
var
  ANeedCount: Integer;
begin
  if AtomicDecrement(FDisableCount) = 0 then
  begin
    if (FSimpleJobs.Count > 0) or (FRepeatJobs.Count > 0) then
    begin
      ANeedCount := FSimpleJobs.Count + FRepeatJobs.Count;
      while ANeedCount > 0 do
      begin
        if not LookupIdleWorker(True) then
          Break;
        Dec(ANeedCount);
      end;
    end;
  end;
end;

function TQWorkers.EnumJobStates: TQJobStateArray;
var
  AJob: PQJob;
  I: Integer;
  ARunnings: TQJobStateArray;
  procedure EnumSimpleJobs(ASimpleJobs: TQSimpleJobs);
  var
    AFirst: PQJob;
  begin
    I := Length(Result);
    AFirst := ASimpleJobs.PopAll;
    AJob := AFirst;
    SetLength(Result, 4096);
    while AJob <> nil do
    begin
      if I >= Length(Result) then
        SetLength(Result, Length(Result) + 4096);
      Assert(AJob.Handle <> 0);
      Result[I].Handle := AJob.Handle;
{$IFDEF UNICODE}
      if AJob.IsAnonWorkerProc then
        TQJobProcA(Result[I].Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
      else
{$ENDIF}
        Result[I].Proc := AJob.WorkerProc;
      Result[I].Flags := AJob.Flags;
      Result[I].PushTime := AJob.PushTime;
      if AJob.IsByPlan then
      begin
        Result[I].Plan := AJob.ExtData.AsPlan.Plan;
        Result[I].Runs := AJob.Runs;
        Result[I].PopTime := AJob.PopTime;
        Result[I].AvgTime := AJob.AvgTime;
        Result[I].TotalTime := AJob.TotalUsedTime;
        Result[I].MaxTime := AJob.MaxUsedTime;
        Result[I].MinTime := AJob.MinUsedTime;
        Result[I].NextTime :=
          Trunc((AJob.ExtData.AsPlan.Plan.NextTime - Now) * Q1Day);
      end;
      AJob := AJob.Next;
      Inc(I);
    end;
    ASimpleJobs.Repush(AFirst);
    SetLength(Result, I);
  end;
  procedure EnumRepeatJobs;
  var
    ANode: TQRBNode;
    ATemp: TQJobStateArray;
    L: Integer;
  begin
    I := 0;
    FRepeatJobs.FLocker.Enter;
    try
      ANode := FRepeatJobs.FItems.First;
      SetLength(ATemp, FRepeatJobs.Count);
      while ANode <> nil do
      begin
        AJob := ANode.Data;
        while Assigned(AJob) do
        begin
          Assert(AJob.Handle <> 0);
          ATemp[I].Handle := AJob.Handle;
{$IFDEF UNICODE}
          if AJob.IsAnonWorkerProc then
            TQJobProcA(ATemp[I].Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
          else
{$ENDIF}
            ATemp[I].Proc := AJob.WorkerProc;
          ATemp[I].Flags := AJob.Flags;
          ATemp[I].Runs := AJob.Runs;
          ATemp[I].PushTime := AJob.PushTime;
          ATemp[I].PopTime := AJob.PopTime;
          ATemp[I].AvgTime := AJob.AvgTime;
          ATemp[I].TotalTime := AJob.TotalUsedTime;
          ATemp[I].MaxTime := AJob.MaxUsedTime;
          ATemp[I].MinTime := AJob.MinUsedTime;
          ATemp[I].NextTime := AJob.NextTime;
          AJob := AJob.Next;
          Inc(I);
        end;
        ANode := ANode.Next;
      end;
    finally
      FRepeatJobs.FLocker.Leave;
    end;
    if I > 0 then
    begin
      L := Length(Result);
      SetLength(Result, Length(Result) + I);
      Move(ATemp[0], Result[L], I * SizeOf(TQJobState));
    end;
  end;
  procedure EnumSignalJobs;
  var
    ATemp: TQJobStateArray;
    AList: PQHashList;
    ASignal: PQSignal;
    L: Integer;
  begin
    L := 0;
    I := 0;
    FLocker.Enter;
    try
      SetLength(ATemp, 4096);
      while I < FSignalJobs.BucketCount do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            while AJob <> nil do
            begin
              if L >= Length(ATemp) then
                SetLength(ATemp, Length(ATemp) + 4096);
              ATemp[L].Handle := AJob.Handle;
{$IFDEF UNICODE}
              if AJob.IsAnonWorkerProc then
                TQJobProcA(ATemp[I].Proc.ProcA) :=
                  TQJobProcA(AJob.WorkerProc.ProcA)
              else
{$ENDIF}
                ATemp[L].Proc := AJob.WorkerProc;
              ATemp[L].Runs := AJob.Runs;
              ATemp[L].Flags := AJob.Flags;
              ATemp[L].PushTime := AJob.PushTime;
              ATemp[L].PopTime := AJob.PopTime;
              ATemp[L].AvgTime := AJob.AvgTime;
              ATemp[L].TotalTime := AJob.TotalUsedTime;
              ATemp[L].MaxTime := AJob.MaxUsedTime;
              ATemp[L].MinTime := AJob.MinUsedTime;
              AJob := AJob.Next;
              Inc(L);
            end;
          end;
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
    end;
    if L > 0 then
    begin
      I := Length(Result);
      SetLength(Result, Length(Result) + L);
      Move(ATemp[0], Result[I], L * SizeOf(TQJobState));
    end;
  end;
  procedure CheckRunnings;
  var
    C: Integer;
    J: Integer;
    AFound: Boolean;
  begin
    DisableWorkers;
    C := 0;
    FLocker.Enter;
    try
      SetLength(ARunnings, FWorkerCount);
      I := 0;
      while I < FWorkerCount do
      begin
        if FWorkers[I].IsExecuting then
        begin
          ARunnings[C].Handle := FWorkers[I].FActiveJob.Handle;
          ARunnings[C].Proc := FWorkers[I].FActiveJobProc;
          ARunnings[C].Flags := FWorkers[I].FActiveJobFlags;
          ARunnings[C].IsRunning := True;
          ARunnings[C].EscapedTime := GetTimestamp - FWorkers[I]
            .FLastActiveTime;
          ARunnings[C].PopTime := FWorkers[I].FLastActiveTime;
          Inc(C);
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
    SetLength(ARunnings, C);
    I := 0;
    while I < C do
    begin
      AFound := False;
      for J := 0 to High(Result) do
      begin
        if ARunnings[I].Handle = Result[J].Handle then
        begin
          AFound := True;
          Break;
        end;
      end;
      if not AFound then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := ARunnings[I];
      end;
      Inc(I);
    end;
  end;

  function IsRunning(AHandle: IntPtr): Boolean;
  var
    J: Integer;
  begin
    AHandle := AHandle and (not $03);
    Result := False;
    for J := 0 to High(ARunnings) do
    begin
      if AHandle = ARunnings[J].Handle then
      begin
        Result := True;
        Break;
      end;
    end;
  end;

begin
  SetLength(Result, 0);
  EnumSimpleJobs(FSimpleJobs);
  EnumSimpleJobs(FPlanJobs);
  EnumRepeatJobs;
  EnumSignalJobs;
  CheckRunnings;
  for I := 0 to High(Result) do
    Result[I].IsRunning := IsRunning(Result[I].Handle);
end;

function TQWorkers.EnumWorkerStatus: TQWorkerStatus;
var
  I: Integer;
  function GetMethodName(AMethod: TMethod): QStringW;
  var
    AObjName, AMethodName: QStringW;
{$IFDEF USE_MAP_SYMBOLS}
    ALoc: TQSymbolLocation;
{$ENDIF}
  begin
    if AMethod.Data <> nil then
    begin
      try
        AObjName := TObject(TObject(AMethod.Data)).ClassName;
{$IFDEF USE_MAP_SYMBOLS}
        if LocateSymbol(AMethod.Code, ALoc) then
        begin
          Result := ALoc.FunctionName;
          Exit;
        end
        else
          AMethodName := TObject(AMethod.Data).MethodName(AMethod.Code);
{$ELSE}
        AMethodName := TObject(AMethod.Data).MethodName(AMethod.Code);
{$ENDIF}
      except
        AObjName := IntToHex(NativeInt(AMethod.Data), SizeOf(Pointer) shl 1);
      end;
      if Length(AObjName) = 0 then
        AObjName := IntToHex(NativeInt(AMethod.Data), SizeOf(Pointer) shl 1);
      if Length(AMethodName) = 0 then
        AMethodName := IntToHex(NativeInt(AMethod.Code), SizeOf(Pointer) shl 1);
      Result := AObjName + '::' + AMethodName;
    end
    else if AMethod.Data <> nil then
      Result := IntToHex(NativeInt(AMethod.Code), SizeOf(Pointer) shl 1)
    else
      SetLength(Result, 0);
  end;

begin
  DisableWorkers;
  FLocker.Enter;
  try
    SetLength(Result, Workers);
    for I := 0 to Workers - 1 do
    begin
      Result[I].Processed := FWorkers[I].FProcessed;
      Result[I].ThreadId := FWorkers[I].ThreadId;
      Result[I].IsIdle := FWorkers[I].IsIdle;
      Result[I].LastActive := FWorkers[I].FLastActiveTime;
      Result[I].Timeout := FWorkers[I].FTimeout;
      if not Result[I].IsIdle then
      begin
        Result[I].ActiveJob :=
          GetMethodName(TMethod(FWorkers[I].FActiveJobProc));
        if Assigned(GetThreadStackInfo) then
          Result[I].Stacks := GetThreadStackInfo(FWorkers[I]);
      end;
    end;
  finally
    FLocker.Leave;
    EnableWorkers;
  end;
end;

procedure TQWorkers.FireSignalJob(ASignal: PQSignal; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  AJob, ACopy: PQJob;
  ACount: PInteger;
begin
  Inc(ASignal.Fired);
  if AData <> nil then
  begin
    New(ACount);
    ACount^ := 1; // ��ʼֵ
  end
  else
    ACount := nil;
  AJob := ASignal.First;
  while AJob <> nil do
  begin
    ACopy := JobPool.Pop;
    ACopy.Assign(AJob);
    JobInitialize(ACopy, AData, AFreeType, True, AJob.InMainThread);
    if ACount <> nil then
    begin
      AtomicIncrement(ACount^);
      ACopy.RefCount := ACount;
    end;
    ACopy.Source := AJob;
    FSimpleJobs.Push(ACopy);
    AJob := AJob.Next;
  end;
  if AData <> nil then
  begin
    if AtomicDecrement(ACount^) = 0 then
    begin
      Dispose(ACount);
      FreeJobData(AData, AFreeType);
    end;
  end;
end;

procedure TQWorkers.FreeJob(AJob: PQJob);
var
  ANext: PQJob;
  AFreeData: Boolean;
begin
  CheckWaitChain(AJob);
  while AJob <> nil do
  begin
    ANext := AJob.Next;
    if AJob.Data <> nil then
    begin
      if AJob.IsSignalWakeup then
      begin
        AFreeData := AtomicDecrement(AJob.RefCount^) = 0;
        if AFreeData then
          Dispose(AJob.RefCount);
      end
      else
        AFreeData := AJob.IsDataOwner;
      if AFreeData then
        FreeJobData(AJob.Data, AJob.FreeType);
    end;
    JobPool.Push(AJob);
    AJob := ANext;
  end;
end;

procedure TQWorkers.FreeJobData(AData: Pointer; AFreeType: TQJobDataFreeType);
begin
  if AData <> nil then
  begin
    try
      case AFreeType of
        jdfFreeAsObject:
          FreeObject(TObject(AData));
        jdfFreeAsSimpleRecord:
            Dispose(AData);
        jdfFreeAsInterface:
          IUnknown(AData)._Release
      else
        DoCustomFreeData(AFreeType, AData);
      end;
    except
      on E: Exception do
        if Assigned(FOnError) then
          FOnError(nil, E, jesFreeData);
    end;
  end;
end;

function TQWorkers.GetBusyCount: Integer;
begin
  Result := FBusyCount;
end;

function TQWorkers.GetEnabled: Boolean;
begin
  Result := (FDisableCount = 0);
end;

function TQWorkers.GetIdleWorkers: Integer;
begin
  Result := FWorkerCount - BusyWorkers;
end;

function TQWorkers.GetNextRepeatJobTime: Int64;
begin
  Result := FRepeatJobs.FFirstFireTime;
end;

function TQWorkers.GetOutWorkers: Boolean;
begin
  Result := (FBusyCount = MaxWorkers);
end;

function TQWorkers.HandleToJob(const AHandle: IntPtr): PQJob;
begin
  Result := PQJob(AHandle and (not IntPtr(3)));
end;

function TQWorkers.LongtimeJob(AProc: TQJobProc; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, True, False);
    AJob.SetFlags(JOB_LONGTIME, True);
{$IFDEF NEXTGEN}
    PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
    AJob.WorkerProc.Proc := AProc;
{$ENDIF}
    Result := Post(AJob);
  end
  else
  begin
    AtomicDecrement(FLongTimeWorkers);
    Result := 0;
  end;
end;
{$IFDEF UNICODE}

function TQWorkers.LongtimeJob(AProc: TQJobProcA; AData: Pointer;
  AFreeType: TQJobDataFreeType = jdfFreeByUser): IntPtr;
var
  AJob: PQJob;
begin
  if AtomicIncrement(FLongTimeWorkers) <= FMaxLongtimeWorkers then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, AData, AFreeType, True, False);
    AJob.SetFlags(JOB_LONGTIME, True);
    TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
    AJob.IsAnonWorkerProc := True;
    Result := Post(AJob);
  end
  else
  begin
    AtomicDecrement(FLongTimeWorkers);
    Result := 0;
  end;
end;
{$ENDIF}

function TQWorkers.LongtimeJob(AProc: TQJobProcG; AData: Pointer;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := LongtimeJob(MakeJobProc(AProc), AData, AFreeType);
end;

function TQWorkers.LookupIdleWorker(AFromStatic: Boolean): Boolean;
var
  AWorker: TQWorker;
  I: Integer;
  APendingCount, APasscount: Integer;
  procedure InternalLookupWorker;
  begin
    FLocker.Enter;
    try
      I := 0;
      while I < FWorkerCount do
      begin
        if (FWorkers[I].IsIdle) and (FWorkers[I].IsRunning) and
          (not FWorkers[I].IsFiring) then
        begin
          if AWorker = nil then
          begin
            if not FWorkers[I].FPending then
            begin
              AWorker := FWorkers[I];
              AWorker.FPending := True;
              AWorker.FEvent.SetEvent;
              Break;
            end
            else
              Inc(APendingCount);
          end;
        end;
        Inc(I);
      end;
      if FWorkerCount = MaxWorkers then // ����Ѿ���������ߣ��Ͳ���������
        APasscount := -1
      else if (AWorker = nil) and (APendingCount = 0) then
      // δ�ҵ���û�������еĹ����ߣ����Դ����µ�
      begin
        // OutputDebugString(PChar(Format('Pending %d,Passcount %d',
        // [APendingCount, APasscount])));
        AWorker := CreateWorker(False);
      end;
    finally
      FLocker.Leave;
    end;
  end;

begin
  Result := False;
  if FBusyCount >= FMaxWorkers then
    Exit
  else if (FDisableCount <> 0) or FTerminating then
    Exit;
  AWorker := nil;
  APasscount := 0;
  repeat
    APendingCount := 0;
    // ��������ڽ�͵Ĺ����ߣ���ô�ȴ����
    while FFiringWorkerCount > 0 do
      ThreadYield;
    InternalLookupWorker;
    if (AWorker = nil) and (APendingCount > 0) then
    begin
      // ���û�ܷ��乤���߲�����δ������ɵĹ����ߣ����л����̵߳�ʱ��Ƭ��Ȼ���ٳ��Լ��
      ThreadYield;
      Inc(APasscount);
    end;
  until (APasscount < 0) or (AWorker <> nil);
  Result := AWorker <> nil;
end;

procedure TQWorkers.NewWorkerNeeded;
begin
  TStaticThread(FStaticThread).CheckNeeded;
end;

function TQWorkers.PeekJobState(AHandle: IntPtr;
  var AResult: TQJobState): Boolean;
var
  AJob: PQJob;
  ARunnings: array of IntPtr;
  procedure PeekSimpleJob(ASimpleJobs: TQSimpleJobs);
  var
    AFirst: PQJob;
  begin
    AFirst := ASimpleJobs.PopAll;
    AJob := AFirst;
    while AJob <> nil do
    begin
      if IntPtr(AJob) = AHandle then
      begin
        AResult.Handle := IntPtr(AJob);
{$IFDEF UNICODE}
        if AJob.IsAnonWorkerProc then
          TQJobProcA(AResult.Proc.ProcA) := TQJobProcA(AJob.WorkerProc.ProcA)
        else
{$ENDIF}
          AResult.Proc := AJob.WorkerProc;
        AResult.Flags := AJob.Flags;
        AResult.PushTime := AJob.PushTime;
        if AJob.IsByPlan then
        begin
          AResult.Runs := AJob.Runs;
          AResult.PushTime := AJob.PushTime;
          AResult.PopTime := AJob.PopTime;
          AResult.AvgTime := AJob.AvgTime;
          AResult.TotalTime := AJob.TotalUsedTime;
          AResult.MaxTime := AJob.MaxUsedTime;
          AResult.MinTime := AJob.MinUsedTime;
          AResult.NextTime :=
            Trunc((AJob.ExtData.AsPlan.Plan.NextTime - Now) * Q1Day);
        end;
        Result := True;
        Break;
      end;
      AJob := AJob.Next;
    end;
    ASimpleJobs.Repush(AFirst);
  end;
  procedure PeekRepeatJob;
  var
    ANode: TQRBNode;
  begin
    AHandle := AHandle and (not $03);
    FRepeatJobs.FLocker.Enter;
    try
      ANode := FRepeatJobs.FItems.First;
      while ANode <> nil do
      begin
        AJob := ANode.Data;
        while Assigned(AJob) do
        begin
          if IntPtr(AJob) = AHandle then
          begin
            AResult.Handle := IntPtr(AJob) or $01;
{$IFDEF UNICODE}
            if AJob.IsAnonWorkerProc then
              TQJobProcA(AResult.Proc.ProcA) :=
                TQJobProcA(AJob.WorkerProc.ProcA)
            else
{$ENDIF}
              AResult.Proc := AJob.WorkerProc;
            AResult.Flags := AJob.Flags;
            AResult.Runs := AJob.Runs;
            AResult.PushTime := AJob.PushTime;
            AResult.PopTime := AJob.PopTime;
            AResult.AvgTime := AJob.AvgTime;
            AResult.TotalTime := AJob.TotalUsedTime;
            AResult.MaxTime := AJob.MaxUsedTime;
            AResult.MinTime := AJob.MinUsedTime;
            AResult.NextTime := AJob.NextTime;
            Result := True;
            Exit;
          end;
          AJob := AJob.Next;
        end;
        ANode := ANode.Next;
      end;
    finally
      FRepeatJobs.FLocker.Leave;
    end;
  end;
  procedure PeekSignalJob;
  var
    ATemp: TQJobStateArray;
    AList: PQHashList;
    ASignal: PQSignal;
    I: Integer;
  begin
    I := 0;
    AHandle := AHandle and (not $03);
    FLocker.Enter;
    try
      SetLength(ATemp, 4096);
      while I < FSignalJobs.BucketCount do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            while AJob <> nil do
            begin
              if IntPtr(AJob) = AHandle then
              begin
                AResult.Handle := AJob.Handle;
{$IFDEF UNICODE}
                if AJob.IsAnonWorkerProc then
                  TQJobProcA(AResult.Proc.ProcA) :=
                    TQJobProcA(AJob.WorkerProc.ProcA)
                else
{$ENDIF}
                  AResult.Proc := AJob.WorkerProc;
                AResult.Runs := AJob.Runs;
                AResult.Flags := AJob.Flags;
                AResult.PushTime := AJob.PushTime;
                AResult.PopTime := AJob.PopTime;
                AResult.AvgTime := AJob.AvgTime;
                AResult.TotalTime := AJob.TotalUsedTime;
                AResult.MaxTime := AJob.MaxUsedTime;
                AResult.MinTime := AJob.MinUsedTime;
                Result := True;
                Exit;
              end;
              AJob := AJob.Next;
            end;
          end;
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
    end;
  end;
  procedure CheckRunnings;
  var
    I: Integer;
  begin
    DisableWorkers;
    FLocker.Enter;
    try
      SetLength(ARunnings, FWorkerCount);
      I := 0;
      while I < FWorkerCount do
      begin
        if FWorkers[I].IsExecuting then
        begin
          if IntPtr(FWorkers[I].FActiveJob) = AHandle then
          begin
            AResult.IsRunning := True;
            Exit;
          end;
        end;
        Inc(I);
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
  end;

begin
  Result := False;
  case AHandle and $03 of
    0:
      PeekSimpleJob(FSimpleJobs);
    1:
      PeekRepeatJob;
    2:
      PeekSignalJob;
    3:
      PeekSimpleJob(FPlanJobs);
  end;
  CheckRunnings;
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: QStringW;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProcG; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(MakeJobProc(AProc), APlan, AData, ARunInMainThread, AFreeType);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, TQJobExtData.Create(APlan, AData, AFreeType),
    jdfFreeAsObject, False, ARunInMainThread);
  AJob.IsByPlan := True;
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := Post(AJob);
end;

function TQWorkers.Plan(AProc: TQJobProc; const APlan: QStringW; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

{$IFDEF UNICODE}

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: TQPlanMask;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, TQJobExtData.Create(APlan, AData, AFreeType),
    jdfFreeAsObject, False, ARunInMainThread);
  AJob.IsByPlan := True;
  AJob.IsAnonWorkerProc := True;
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  Result := Post(AJob);
end;

function TQWorkers.Plan(AProc: TQJobProcA; const APlan: QStringW;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Plan(AProc, TQPlanMask.Create(APlan), AData, ARunInMainThread,
    AFreeType);
end;

{$ENDIF}

procedure TQWorkers.PlanCheckNeeded;
var
  H, M, S, MS: Word;
begin
  if FPlanCheckJob = 0 then
  begin
    FLocker.Enter;
    try
      if FPlanCheckJob = 0 then // �ٴμ�飬�Ա������жϺ���������֮ǰ������߳��Ѿ�ִ�й��˶δ���
      begin
        DecodeTime(Now, H, M, S, MS);
        // �޸��ӳ٣��Ա㾡����ȷ�����ӵ�0��
        FPlanCheckJob := At(DoPlanCheck, ((60 - S) * 1000 - MS) * Q1MillSecond,
          Q1Second, nil, False);
      end;
    finally
      FLocker.Leave;
    end;
  end;
end;

function TQWorkers.Popup: PQJob;
begin
  Result := FSimpleJobs.Pop;
  if Result = nil then
    Result := FRepeatJobs.Pop;
end;

function TQWorkers.RegisterSignal(const AName: QStringW): Integer;
var
  ASignal: PQSignal;
begin
  FLocker.Enter;
  try
    Result := SignalIdByName(AName);
    if Result < 0 then
    begin
      Inc(FMaxSignalId);
      New(ASignal);
      ASignal.Id := FMaxSignalId;
      ASignal.Fired := 0;
      ASignal.Name := AName;
      ASignal.First := nil;
      FSignalJobs.Add(ASignal, ASignal.Id);
      Result := ASignal.Id;
      // OutputDebugString(PWideChar('Signal '+IntToStr(ASignal.Id)+' Allocate '+IntToHex(NativeInt(ASignal),8)));
    end;
  finally
    FLocker.Leave;
  end;
end;

procedure TQWorkers.SetEnabled(const Value: Boolean);
begin
  if Value then
    EnableWorkers
  else
    DisableWorkers;
end;

procedure TQWorkers.SetFireTimeout(const Value: Cardinal);
begin
  if Value = 0 then
    FFireTimeout := MaxInt
  else
    FFireTimeout := Value;
end;

procedure TQWorkers.SetMaxLongtimeWorkers(const Value: Integer);
begin
  if FMaxLongtimeWorkers <> Value then
  begin
    if Value > (MaxWorkers shr 1) then
      raise Exception.Create(STooManyLongtimeWorker);
    FMaxLongtimeWorkers := Value;
  end;
end;

procedure TQWorkers.SetMaxWorkers(const Value: Integer);
var
  ATemp, AMaxLong: Integer;
begin
  if Value < FMinWorkers then
    raise Exception.Create(SMaxMinWorkersError);
  if (Value >= 2) and (FMaxWorkers <> Value) then
  begin
    AtomicExchange(ATemp, FLongTimeWorkers);
    AtomicExchange(FMaxLongtimeWorkers, 0); // ǿ����0����ֹ������ĳ�ʱ����ҵ
    AMaxLong := Value shr 1;
    FLocker.Enter;
    try
      if Value > FMinWorkers then
        FMinWorkers := Value;
      if FLongTimeWorkers < AMaxLong then // �Ѿ����еĳ�ʱ����ҵ��С��һ��Ĺ�����
      begin
        if (ATemp > 0) and (ATemp < AMaxLong) then
          AMaxLong := ATemp;
        if FMaxWorkers > Value then
        begin
          FMaxWorkers := Value;
          SetLength(FWorkers, Value + 1);
        end
        else
        begin
          FMaxWorkers := Value;
          SetLength(FWorkers, Value + 1);
        end;
      end;
    finally
      FLocker.Leave;
      AtomicExchange(FMaxLongtimeWorkers, AMaxLong);
    end;
  end;
end;

procedure TQWorkers.SetMinWorkers(const Value: Integer);
begin
  if FMinWorkers <> Value then
  begin
    if (Value < 1) then
      raise Exception.Create(STooFewWorkers)
    else if Value > FMaxWorkers then
      raise Exception.Create(SMaxMinWorkersError);
    FMinWorkers := Value;
  end;
end;

procedure TQWorkers.Signal(AId: Integer; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  AFound: Boolean;
  ASignal: PQSignal;
begin
  AFound := False;
  FLocker.Enter;
  try
    ASignal := FSignalJobs.FindFirstData(AId);
    if ASignal <> nil then
    begin
      AFound := True;
      FireSignalJob(ASignal, AData, AFreeType);
    end
    else
      FreeJobData(AData, AFreeType);
  finally
    FLocker.Leave;
  end;
  if AFound then
    LookupIdleWorker(True);
end;

procedure TQWorkers.Signal(const AName: QStringW; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  I: Integer;
  ASignal: PQSignal;
  AFound: Boolean;
begin
  AFound := False;
  FLocker.Enter;
  try
    for I := 0 to FSignalJobs.BucketCount - 1 do
    begin
      if FSignalJobs.Buckets[I] <> nil then
      begin
        ASignal := FSignalJobs.Buckets[I].Data;
        if (Length(ASignal.Name) = Length(AName)) and (ASignal.Name = AName)
        then
        begin
          AFound := True;
          FireSignalJob(ASignal, AData, AFreeType);
          Break;
        end;
      end;
    end;
  finally
    FLocker.Leave;
  end;
  if AFound then
    LookupIdleWorker(True)
  else
    FreeJobData(AData, AFreeType);
end;

function TQWorkers.SignalIdByName(const AName: QStringW): Integer;
var
  I: Integer;
  ASignal: PQSignal;
begin
  Result := -1;
  for I := 0 to FSignalJobs.BucketCount - 1 do
  begin
    if FSignalJobs.Buckets[I] <> nil then
    begin
      ASignal := FSignalJobs.Buckets[I].Data;
      if (Length(ASignal.Name) = Length(AName)) and (ASignal.Name = AName) then
      begin
        Result := ASignal.Id;
        Exit;
      end;
    end;
  end;
end;

procedure TQWorkers.SignalWorkDone(AJob: PQJob; AUsedTime: Int64);
var
  ASignal: PQSignal;
  ATemp, APrior: PQJob;
begin
  FLocker.Enter;
  try
    ASignal := FSignalJobs.FindFirstData(AJob.SignalId);
    ATemp := ASignal.First;
    APrior := nil;
    while ATemp <> nil do
    begin
      if ATemp = AJob.Source then
      begin
        if AJob.IsTerminated then
        begin
          if APrior <> nil then
            APrior.Next := ATemp.Next
          else
            ASignal.First := ATemp.Next;
          ATemp.Next := nil;
          FreeJob(ATemp);
        end
        else
        begin
          // �����ź���ҵ��ͳ����Ϣ
          Inc(ATemp.Runs);
          if AUsedTime > 0 then
          begin
            if ATemp.MinUsedTime = 0 then
              ATemp.MinUsedTime := AUsedTime
            else if AUsedTime < ATemp.MinUsedTime then
              ATemp.MinUsedTime := AUsedTime;
            if ATemp.MaxUsedTime = 0 then
              ATemp.MaxUsedTime := AUsedTime
            else if AUsedTime > ATemp.MaxUsedTime then
              ATemp.MaxUsedTime := AUsedTime;
            Break;
          end;
        end;
      end;
      APrior := ATemp;
      ATemp := ATemp.Next;
    end;
  finally
    FLocker.Leave;
  end;
end;

procedure TQWorkers.ValidWorkers;
{$IFDEF VALID_WORKERS}
var
  I: Integer;
{$ENDIF}
begin
{$IFDEF VALID_WORKERS}
  for I := 0 to FWorkerCount - 1 do
  begin
    if FWorkers[I] = nil then
      OutputDebugString('Workers array bad')
    else if FWorkers[I].FIndex <> I then
      OutputDebugString('Workers index bad');
  end;
{$ENDIF}
end;

procedure TQWorkers.WorkerTimeout(AWorker: TQWorker);
var
  AWorkers: Integer;
begin
  AWorkers := FWorkerCount - AtomicIncrement(FFiringWorkerCount);
  if (AWorkers < FMinWorkers) or (AWorkers = BusyWorkers) then // ������1������
    AtomicDecrement(FFiringWorkerCount)
  else
  begin
    AWorker.SetFlags(WORKER_FIRING, True);
    AWorker.Terminate;
  end;
end;

procedure TQWorkers.WorkerTerminate(AWorker: TQWorker);
var
  I, J: Integer;
begin
  FLocker.Enter;
  try
    Dec(FWorkerCount);
    if AWorker.IsFiring then
      AtomicDecrement(FFiringWorkerCount);
    // ����ǵ�ǰæµ�Ĺ����߱����
    if FWorkerCount = 0 then
      FWorkers[0] := nil
    else
    begin
      for I := 0 to FWorkerCount do
      begin
        if AWorker = FWorkers[I] then
        begin
          for J := I to FWorkerCount do
            FWorkers[J] := FWorkers[J + 1];
          Break;
        end;
      end;
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQWorkers.Wait(AProc: TQJobProc; ASignalId: Integer;
  ARunInMainThread: Boolean): IntPtr;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
  if not FTerminating then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, nil, jdfFreeByUser, False, ARunInMainThread);
{$IFDEF NEXTGEN}
    PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
    AJob.WorkerProc.Proc := AProc;
{$ENDIF}
    // Assert(AJob.WorkerProc.Code<>nil);
    AJob.SignalId := ASignalId;
    AJob.SetFlags(JOB_SIGNAL_WAKEUP, True);
    AJob.PushTime := GetTimestamp;
    Result := 0;
    FLocker.Enter;
    try
      ASignal := FSignalJobs.FindFirstData(ASignalId);
      if ASignal <> nil then
      begin
        AJob.Next := ASignal.First;
        ASignal.First := AJob;
        Result := AJob.Handle;
      end;
    finally
      FLocker.Leave;
      if Result = 0 then
        JobPool.Push(AJob);
    end;
  end
  else
    Result := 0;
end;
{$IFDEF UNICODE}

function TQWorkers.Wait(AProc: TQJobProcA; ASignalId: Integer;
  ARunInMainThread: Boolean): IntPtr;
var
  AJob: PQJob;
  ASignal: PQSignal;
begin
  if not FTerminating then
  begin
    AJob := JobPool.Pop;
    JobInitialize(AJob, nil, jdfFreeByUser, False, ARunInMainThread);
    TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
    AJob.IsAnonWorkerProc := True;
    AJob.SignalId := ASignalId;
    AJob.SetFlags(JOB_SIGNAL_WAKEUP, True);
    AJob.PushTime := GetTimestamp;
    Result := 0;
    FLocker.Enter;
    try
      ASignal := FSignalJobs.FindFirstData(ASignalId);
      if ASignal <> nil then
      begin
        AJob.Next := ASignal.First;
        ASignal.First := AJob;
        Result := AJob.Handle;
      end;
    finally
      FLocker.Leave;
      if Result = 0 then
        JobPool.Push(AJob);
    end;
  end
  else
    Result := 0;
end;

{$ENDIF}

function TQWorkers.WaitJob(AHandle: IntPtr; ATimeout: Cardinal;
  AMsgWait: Boolean): TWaitResult;
var
  AFirst, AJob: PQJob;
  AChain: PQJobWaitChain;
  I: Integer;
  procedure AddWait;
  begin
    New(AChain);
    AChain.Event := TEvent.Create(nil, False, False, '');
    AChain.Job := AHandle;
    AChain.Prior := nil;
    FLocker.Enter;
    if Assigned(FLastWaitChain) then
      FLastWaitChain.Prior := AChain;
    FLastWaitChain := AChain;
    FLocker.Leave;
  end;
  procedure RemoveWait;
  var
    APrior, ANext: PQJobWaitChain;
  begin
    if Assigned(AChain) then
    begin
      ANext := nil;
      FLocker.Enter;
      try
        APrior := FLastWaitChain;
        while Assigned(APrior) do
        begin
          if APrior = AChain then
          begin
            if Assigned(ANext) then
              ANext.Prior := APrior.Prior
            else
              FLastWaitChain := APrior.Prior;
            Break;
          end;
          ANext := APrior;
          APrior := APrior.Prior;
        end;
      finally
        FLocker.Leave;
        FreeAndNil(AChain.Event);
        Dispose(AChain);
      end;
    end;
  end;

begin
  if (AHandle and $3) = 0 then
  begin
    AChain := nil;
    try
      AFirst := FSimpleJobs.PopAll;
      try
        AJob := AFirst;
        while AJob <> nil do
        begin
          if AHandle = IntPtr(AJob) then
          begin
            AddWait;
            Break;
          end
          else
            AJob := AJob.Next;
        end;
      finally
        FSimpleJobs.Repush(AFirst);
        LookupIdleWorker(False);
      end;
      if not Assigned(AChain) then
      begin
        FLocker.Enter;
        try
          for I := 0 to FWorkerCount - 1 do
          begin
            if IntPtr(FWorkers[I].FActiveJob) = AHandle then
            begin
              AddWait;
              Break;
            end;
          end;
        finally
          FLocker.Leave;
        end;
      end;
      if Assigned(AChain) then
      begin
        if AMsgWait then
          Result := MsgWaitForEvent(AChain.Event, ATimeout)
        else
          Result := TEvent(AChain.Event).WaitFor(ATimeout);
      end
      else
        Result := wrSignaled;
    finally
      RemoveWait;
    end;
  end
  else
    Result := wrError;
end;

function TQWorkers.Wait(AProc: TQJobProcG; ASignalId: Integer;
  ARunInMainThread: Boolean): IntPtr;
begin
  Result := Wait(MakeJobProc(AProc), ASignalId, ARunInMainThread);
end;

procedure TQWorkers.WaitRunningDone(const AParam: TWorkerWaitParam);
var
  AInMainThread: Boolean;
  function HasJobRunning: Boolean;
  var
    I: Integer;
    AJob: PQJob;
  begin
    Result := False;
    DisableWorkers;
    FLocker.Enter;
    try
      for I := 0 to FWorkerCount - 1 do
      begin
        if FWorkers[I].IsLookuping then // ��δ�������������´β�ѯ
        begin
          Result := True;
          Break;
        end
        else if FWorkers[I].IsExecuting then
        begin
          if not FWorkers[I].IsCleaning then
          begin
            AJob := FWorkers[I].FActiveJob;
            case AParam.WaitType of
              0: // ByObject
                Result := TMethod(FWorkers[I].FActiveJobProc)
                  .Data = AParam.Bound;
              1:
                // ByData
                Result := (TMethod(FWorkers[I].FActiveJobProc)
                  .Code = TMethod(AParam.WorkerProc).Code) and
                  (TMethod(FWorkers[I].FActiveJobProc)
                  .Data = TMethod(AParam.WorkerProc).Data) and
                  ((AParam.Data = INVALID_JOB_DATA) or
                  (FWorkers[I].FActiveJobData = AParam.Data));
              2: // BySignalSource
                Result := (FWorkers[I].FActiveJobSource = AParam.SourceJob);
              3, 5: // ByGroup,ByPlan: Group/PlanSource��ͬһ��ַ
                Result := (FWorkers[I].FActiveJobGroup = AParam.Group);
              4: // ByJob
                Result := (AJob = AParam.SourceJob);
              $FF: // ����
                Result := True;
            else
              begin
                if Assigned(FOnError) then
                  FOnError(AJob, Exception.CreateFmt(SBadWaitDoneParam,
                    [AParam.WaitType]), jesWaitDone)
                else
                  raise Exception.CreateFmt(SBadWaitDoneParam,
                    [AParam.WaitType]);
              end;
            end;
            if Result then
              FWorkers[I].FTerminatingJob := AJob;
          end;
        end;
      end;
    finally
      FLocker.Leave;
      EnableWorkers;
    end;
  end;

begin
  AInMainThread := GetCurrentThreadId = MainThreadId;
  repeat
    if HasJobRunning then
    begin
      if AInMainThread then
        // ����������߳���������������ҵ���������߳�ִ�У������Ѿ�Ͷ����δִ�У����Ա��������ܹ�ִ��
        ProcessAppMessage;
      Sleep(10);
    end
    else // û�ҵ�
      Break;
  until 1 > 2;
end;

procedure TQWorkers.WaitSignalJobsDone(AJob: PQJob);
begin
  TEvent(AJob.Data).SetEvent;
end;

function TQWorkers.Clear(ASignalName: QStringW): Integer;
var
  I: Integer;
  ASignal: PQSignal;
  AJob: PQJob;
begin
  Result := 0;
  FLocker.Enter;
  try
    AJob := nil;
    for I := 0 to FSignalJobs.BucketCount - 1 do
    begin
      if FSignalJobs.Buckets[I] <> nil then
      begin
        ASignal := FSignalJobs.Buckets[I].Data;
        if ASignal.Name = ASignalName then
        begin
          AJob := ASignal.First;
          ASignal.First := nil;
          Break;
        end;
      end;
    end;
  finally
    FLocker.Leave;
  end;
  if AJob <> nil then
    ClearSignalJobs(AJob);
end;
{$IFDEF UNICODE}

function TQWorkers.At(AProc: TQJobProcA; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  AJob.IsAnonWorkerProc := True;
  AJob.Interval := AInterval;
  AJob.FirstDelay := ADelay;
  Result := Post(AJob);
end;
{$ENDIF}

function TQWorkers.At(AProc: TQJobProcG; const ADelay, AInterval: Int64;
  AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := At(MakeJobProc(AProc), ADelay, AInterval, AData, ARunInMainThread,
    AFreeType);
end;

function TQWorkers.At(AProc: TQJobProcG; const ATime: TDateTime;
  const AInterval: Int64; AData: Pointer; ARunInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := At(MakeJobProc(AProc), ATime, AInterval, AData, ARunInMainThread,
    AFreeType);
end;

procedure TQWorkers.CheckWaitChain(AJob: PQJob);
  procedure NotifyIfWaiting;
  var
    AChain, APrior, ANext: PQJobWaitChain;
  begin
    AChain := FLastWaitChain;
    ANext := nil;
    while Assigned(AChain) do
    begin
      APrior := AChain.Prior;
      if AChain.Job = IntPtr(AJob) then
      begin
        if Assigned(ANext) then
          ANext.Prior := AChain.Prior
        else
          FLastWaitChain := AChain.Prior;
        TEvent(AChain.Event).SetEvent;
      end;
      AChain := APrior;
    end;
  end;

begin
  if Assigned(FLastWaitChain) then
  begin
    FLocker.Enter;
    try
      while Assigned(AJob) and Assigned(FLastWaitChain) do
      begin
        NotifyIfWaiting;
        AJob := AJob.Next;
      end;
    finally
      FLocker.Leave;
    end;
  end;
end;

function TQWorkers.Clear(ASignalId: Integer): Integer;
var
  I: Integer;
  ASignal: PQSignal;
  AJob: PQJob;
begin
  FLocker.Enter;
  try
    AJob := nil;
    for I := 0 to FSignalJobs.BucketCount - 1 do
    begin
      if FSignalJobs.Buckets[I] <> nil then
      begin
        ASignal := FSignalJobs.Buckets[I].Data;
        if ASignal.Id = ASignalId then
        begin
          AJob := ASignal.First;
          ASignal.First := nil;
          Break;
        end;
      end;
    end;
  finally
    FLocker.Leave;
  end;
  if AJob <> nil then
    Result := ClearSignalJobs(AJob)
  else
    Result := 0;
end;

procedure TQWorkers.Clear;
var
  I: Integer;
  AParam: TWorkerWaitParam;
  ASignal: PQSignal;
begin
  DisableWorkers; // ���⹤����ȡ���µ���ҵ
  try
    FSimpleJobs.Clear;
    FRepeatJobs.Clear;
    FLocker.Enter;
    try
      for I := 0 to FSignalJobs.BucketCount - 1 do
      begin
        if Assigned(FSignalJobs.Buckets[I]) then
        begin
          ASignal := FSignalJobs.Buckets[I].Data;
          FreeJob(ASignal.First);
          ASignal.First := nil;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    AParam.WaitType := $FF;
    WaitRunningDone(AParam);
  finally
    EnableWorkers;
  end;
end;

function TQWorkers.ClearSignalJobs(ASource: PQJob;
  AWaitRunningDone: Boolean): Integer;
var
  AFirst, ALast, APrior, ANext: PQJob;
  ACount: Integer;
  AWaitParam: TWorkerWaitParam;
begin
  Result := 0;
  AFirst := nil;
  APrior := nil;
  FSimpleJobs.FLocker.Enter;
  try
    ALast := FSimpleJobs.FFirst;
    ACount := FSimpleJobs.Count;
    FSimpleJobs.FFirst := nil;
    FSimpleJobs.FLast := nil;
    FSimpleJobs.FCount := 0;
  finally
    FSimpleJobs.FLocker.Leave;
  end;
  while ALast <> nil do
  begin
    if (ALast.IsSignalWakeup) and (ALast.Source = ASource) then
    begin
      ANext := ALast.Next;
      ALast.Next := nil;
      FreeJob(ALast);
      ALast := ANext;
      if APrior <> nil then
        APrior.Next := ANext;
      Dec(ACount);
      Inc(Result);
    end
    else
    begin
      if AFirst = nil then
        AFirst := ALast;
      APrior := ALast;
      ALast := ALast.Next;
    end;
  end;
  if ACount > 0 then
  begin
    FSimpleJobs.FLocker.Enter;
    try
      APrior.Next := FSimpleJobs.FFirst;
      FSimpleJobs.FFirst := AFirst;
      Inc(FSimpleJobs.FCount, ACount);
      if FSimpleJobs.FLast = nil then
        FSimpleJobs.FLast := APrior;
    finally
      FSimpleJobs.FLocker.Leave;
    end;
  end;
  if AWaitRunningDone then
  begin
    AWaitParam.WaitType := 2;
    AWaitParam.SourceJob := ASource;
    WaitRunningDone(AWaitParam);
  end;
  FreeJob(ASource);
end;
{$IFDEF UNICODE}

function TQWorkers.Post(AProc: TQJobProcA; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
var
  AJob: PQJob;
begin
  AJob := JobPool.Pop;
  JobInitialize(AJob, AData, AFreeType, AInterval <= 0, ARunInMainThread);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  AJob.IsAnonWorkerProc := True;
  AJob.Interval := AInterval;
  Result := Post(AJob);
end;

{$ENDIF}

function TQWorkers.Post(AProc: TQJobProcG; AInterval: Int64; AData: Pointer;
  ARunInMainThread: Boolean; AFreeType: TQJobDataFreeType): IntPtr;
begin
  Result := Post(MakeJobProc(AProc), AInterval, AData, ARunInMainThread,
    AFreeType);
end;

procedure TQWorkers.ClearSingleJob(AHandle: IntPtr; AWaitRunningDone: Boolean);
var
  AInstance: PQJob;
  AWaitParam: TWorkerWaitParam;

  function RemoveSignalJob: PQJob;
  var
    I: Integer;
    AJob, ANext, APrior: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
    Result := nil;
    FLocker.Enter;
    try
      for I := 0 to FSignalJobs.BucketCount - 1 do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            APrior := nil;
            while AJob <> nil do
            begin
              ANext := AJob.Next;
              if AJob = AInstance then
              begin
                if ASignal.First = AJob then
                  ASignal.First := ANext;
                if Assigned(APrior) then
                  APrior.Next := ANext;
                AJob.Next := nil;
                Result := AJob;
                Exit;
              end
              else
                APrior := AJob;
              AJob := ANext;
            end;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
  end;
  function ClearSignalJob: Boolean;
  var
    AJob: PQJob;
  begin
    AJob := RemoveSignalJob;
    if Assigned(AJob) then
      ClearSignalJobs(AJob, AWaitRunningDone);
    Result := AJob <> nil;
  end;

begin
  AInstance := HandleToJob(AHandle);
  FillChar(AWaitParam, SizeOf(TWorkerWaitParam), 0);
  AWaitParam.SourceJob := AInstance;
  case AHandle and $03 of
    0:
      // SimpleJobs
      begin
        if FSimpleJobs.Clear(AHandle) then // ����ҵҪô�ڶ����У�Ҫô����
          Exit;
        AWaitParam.WaitType := 4;
      end;
    1: // RepeatJobs
      begin
        if not FRepeatJobs.Clear(IntPtr(AInstance)) then // �ظ�����������ڶ����У�˵���Ѿ��������
          Exit;
        AWaitParam.WaitType := 2;
      end;
    2: // SignalJobs;
      begin
        if ClearSignalJob then
          Exit;
        AWaitParam.WaitType := 2;
      end;
    3: // �ƻ�����
      begin
        FPlanJobs.Clear(IntPtr(AInstance));
        // �ƻ�����Ҫô�ڶ����У�Ҫô��ִ����
        AWaitParam.WaitType := 5;
      end;
  end;
  if AWaitRunningDone then
    WaitRunningDone(AWaitParam);
end;

function TQWorkers.ClearJobs(AHandles: PIntPtr; ACount: Integer): Integer;
var
  ASimpleHandles: array of IntPtr;
  APlanHandles: array of IntPtr;
  ARepeatHandles: array of IntPtr;
  ASignalHandles: array of IntPtr;
  ASimpleCount, ARepeatCount, ASignalCount, APlanCount: Integer;
  I: Integer;
  AWaitParam: TWorkerWaitParam;

  function SignalJobCanRemove(AHandle: IntPtr): Boolean;
  var
    T: Integer;
  begin
    Result := False;
    for T := 0 to ASignalCount - 1 do
    begin
      if ASignalHandles[T] = AHandle then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  function ClearSignals: Integer;
  var
    I: Integer;
    AJob, ANext, APrior, AFirst: PQJob;
    AList: PQHashList;
    ASignal: PQSignal;
  begin
    Result := 0;
    AFirst := nil;
    FLocker.Enter;
    try
      for I := 0 to FSignalJobs.BucketCount - 1 do
      begin
        AList := FSignalJobs.Buckets[I];
        if AList <> nil then
        begin
          ASignal := AList.Data;
          if ASignal.First <> nil then
          begin
            AJob := ASignal.First;
            APrior := nil;
            while AJob <> nil do
            begin
              ANext := AJob.Next;
              if SignalJobCanRemove(IntPtr(AJob)) then
              begin
                if ASignal.First = AJob then
                  ASignal.First := ANext;
                if Assigned(APrior) then
                  APrior.Next := ANext;
                AJob.Next := nil;
                if Assigned(AFirst) then
                  AJob.Next := AFirst;
                AFirst := AJob;
              end
              else
                APrior := AJob;
              AJob := ANext;
              Inc(Result);
            end;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    while AFirst <> nil do
    begin
      ANext := AFirst.Next;
      AFirst.Next := nil;
      ClearSignalJobs(AFirst);
      AFirst := ANext;
    end;
  end;

begin
  Result := 0;
  SetLength(ASimpleHandles, ACount);
  SetLength(ARepeatHandles, ACount);
  SetLength(ASignalHandles, ACount);
  SetLength(APlanHandles, ACount);
  ASimpleCount := 0;
  ARepeatCount := 0;
  ASignalCount := 0;
  APlanCount := 0;
  I := 0;
  while I < ACount do
  begin
    case (IntPtr(AHandles^) and $03) of
      0:
        // Simple Jobs
        begin
          ASimpleHandles[ASimpleCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ASimpleCount);
        end;
      1: // RepeatJobs
        begin
          ARepeatHandles[ARepeatCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ARepeatCount);
        end;
      2: // SignalJobs
        begin
          ASignalHandles[ASignalCount] := (IntPtr(AHandles^) and (not $03));
          Inc(ASignalCount);
        end;
      3: // Plan job
        begin
          APlanHandles[APlanCount] := IntPtr(HandleToJob(AHandles^));
          Inc(APlanCount);
        end;
    end;
    Inc(I);
  end;
  if APlanCount > 0 then
    Inc(Result, FPlanJobs.Clear(@APlanHandles[0], APlanCount));
  if ASimpleCount > 0 then
    Inc(Result, FSimpleJobs.Clear(@ASimpleHandles[0], ASimpleCount));
  if ARepeatCount > 0 then
    Inc(Result, FRepeatJobs.Clear(@ARepeatHandles[0], ARepeatCount));
  if ASignalCount > 0 then
    Inc(Result, ClearSignals);
  FillChar(AWaitParam, SizeOf(TWorkerWaitParam), 0);
  I := 0;
  while I < ASimpleCount do
  begin
    if ASimpleHandles[I] <> 0 then
    begin
      AWaitParam.SourceJob := Pointer(ASimpleHandles[I]);
      AWaitParam.WaitType := 4;
      WaitRunningDone(AWaitParam);
      Inc(Result);
    end;
    Inc(I);
  end;
  I := 0;
  while I < ASimpleCount do
  begin
    if ASimpleHandles[I] <> 0 then
    begin
      AWaitParam.SourceJob := Pointer(APlanHandles[I]);
      AWaitParam.WaitType := 5;
      WaitRunningDone(AWaitParam);
      Inc(Result);
    end;
    Inc(I);
  end;
  I := 0;
  while I < ARepeatCount do
  begin
    if ARepeatHandles[I] <> 0 then
    begin
      AWaitParam.SourceJob := Pointer(ARepeatHandles[I]);
      AWaitParam.WaitType := 2;
      WaitRunningDone(AWaitParam);
      Inc(Result);
    end;
  end;
end;

{ TJobPool }

constructor TJobPool.Create(AMaxSize: Integer);
begin
  inherited Create;
  FSize := AMaxSize;
  FLocker := TQSimpleLock.Create;
end;

destructor TJobPool.Destroy;
var
  AJob: PQJob;
begin
  FLocker.Enter;
  while FFirst <> nil do
  begin
    AJob := FFirst.Next;
    Dispose(FFirst);
    FFirst := AJob;
  end;
  FreeObject(FLocker);
  inherited;
end;

function TJobPool.Pop: PQJob;
begin
  FLocker.Enter;
  Result := FFirst;
  if Result <> nil then
  begin
    FFirst := Result.Next;
    Dec(FCount);
  end;
  FLocker.Leave;
  if Result = nil then
    GetMem(Result, SizeOf(TQJob));
  Result.Reset;
end;

procedure TJobPool.Push(AJob: PQJob);
var
  ADoFree: Boolean;
begin
{$IFDEF UNICODE}
  if AJob.IsAnonWorkerProc then
    TQJobProcA(AJob.WorkerProc.ProcA) := nil
  else
    PQJobProc(@AJob.WorkerProc)^ := nil;
{$ENDIF}
  FLocker.Enter;
  ADoFree := (FCount = FSize);
  if not ADoFree then
  begin
    AJob.Next := FFirst;
    FFirst := AJob;
    Inc(FCount);
  end;
  FLocker.Leave;
  if ADoFree then
  begin
    FreeMem(AJob);
  end;
end;

{ TQSimpleLock }
{$IFDEF QWORKER_SIMPLE_LOCK}

constructor TQSimpleLock.Create;
begin
  inherited;
  FFlags := 0;
end;

procedure TQSimpleLock.Enter;
begin
  while (AtomicOr(FFlags, $01) and $01) <> 0 do
  begin
    GiveupThread;
  end;
end;

procedure TQSimpleLock.Leave;
begin
  AtomicAnd(FFlags, Integer($FFFFFFFE));
end;
{$ENDIF QWORKER_SIMPLE_JOB}
{ TQJobGroup }

function TQJobGroup.Add(AProc: TQJobProc; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := InternalAddJob(AJob);
end;

function TQJobGroup.Add(AProc: TQJobProcG; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
begin
  Result := Add(MakeJobProc(AProc), AData, AInMainThread, AFreeType);
end;
{$IFDEF UNICODE}

function TQJobGroup.Add(AProc: TQJobProcA; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  AJob.IsAnonWorkerProc := True;
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  Result := InternalAddJob(AJob);
end;
{$ENDIF}

procedure TQJobGroup.Cancel(AWaitRunningDone: Boolean);
var
  I: Integer;
  AJob: PQJob;
  AWaitParam: TWorkerWaitParam;
begin
  FLocker.Enter;
  try
    AtomicExchange(FCanceled, 0);
    if FByOrder then
    begin
      I := 0;
      while I < FItems.Count do
      begin
        AJob := FItems[I];
        if AJob.PopTime = 0 then
        begin
          Workers.FreeJob(AJob);
          FItems.Delete(I);
          AtomicIncrement(FCanceled);
        end
        else
          Inc(I);
      end;
    end;
    FItems.Clear;
  finally
    FLocker.Leave;
  end;
  if FPosted <> 0 then
  begin
    I := Workers.FSimpleJobs.Clear(Self, MaxInt);
    if I > 0 then
    begin
      AtomicIncrement(FPosted, -I);
      AtomicIncrement(FCanceled, I);
    end;
    if AWaitRunningDone then
    begin
      AWaitParam.WaitType := 3;
      AWaitParam.Group := Self;
      Workers.WaitRunningDone(AWaitParam);
    end;
  end;
  if FPosted = 0 then
  begin
    if FCanceled > 0 then
      FWaitResult := wrAbandoned;
    FEvent.SetEvent;
  end;
end;

constructor TQJobGroup.Create(AByOrder: Boolean);
begin
  inherited Create;
  FEvent := TEvent.Create(nil, False, False, '');
  FLocker := TQSimpleLock.Create;
  FByOrder := AByOrder;
  FItems := TQJobItemList.Create;
end;

destructor TQJobGroup.Destroy;
var
  I: Integer;
begin
  Cancel;
  if FTimeoutCheck then
    Workers.Clear(Self, 1);
  FLocker.Enter;
  try
    if FItems.Count > 0 then
    begin
      FWaitResult := wrAbandoned;
      FEvent.SetEvent;
      for I := 0 to FItems.Count - 1 do
      begin
        if PQJob(FItems[I]).PushTime <> 0 then
          JobPool.Push(FItems[I]);
      end;
      FItems.Clear;
    end;
  finally
    FLocker.Leave;
  end;
  FreeObject(FLocker);
  FreeObject(FEvent);
  FreeObject(FItems);
  inherited;
end;

procedure TQJobGroup.DoAfterDone;
begin
  try
    if Assigned(FAfterDone) then
      FAfterDone(Self);
  finally
    if FFreeAfterDone then
    begin
      FreeObject(Self);
    end;
  end;
end;

procedure TQJobGroup.DoJobExecuted(AJob: PQJob);
var
  I: Integer;
  AIsDone: Boolean;
begin
  AtomicIncrement(FRuns);
  if FWaitResult = wrIOCompletion then
  begin
    AIsDone := False;
    FLocker.Enter;
    try
      I := FItems.IndexOf(AJob);
      if I <> -1 then
      begin
        FItems.Delete(I);
        if FItems.Count = 0 then
        begin
          AIsDone := True;
          FWaitResult := wrSignaled;
          FEvent.SetEvent;
        end
        else if ByOrder then
        begin
          if Workers.Post(FItems[0]) = 0 then
          begin
            AtomicDecrement(FPosted);
            FItems.Delete(0); // Ͷ��ʧ��ʱ��Post�Զ��ͷ�����ҵ
            FWaitResult := wrAbandoned;
            AIsDone := True;
            FEvent.SetEvent;
          end
        end
        else
          AtomicDecrement(FPosted);
      end
      else
      begin
        AIsDone := (FItems.Count = 0) and (AtomicDecrement(FPosted) = 0);
        if AIsDone then
        begin
          if FCanceled = 0 then
            FWaitResult := wrSignaled
          else
          begin
            FWaitResult := wrAbandoned;
            AtomicExchange(FCanceled, 0);
          end;
          FEvent.SetEvent;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    if AIsDone then
      DoAfterDone;
  end;
end;

procedure TQJobGroup.DoJobsTimeout(AJob: PQJob);
begin
  FTimeoutCheck := False;
  Cancel;
  if FWaitResult = wrIOCompletion then
  begin
    FWaitResult := wrTimeout;
    FEvent.SetEvent;
    DoAfterDone;
  end;
end;

function TQJobGroup.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TQJobGroup.InitGroupJob(AData: Pointer; AInMainThread: Boolean;
  AFreeType: TQJobDataFreeType): PQJob;
begin
  Result := JobPool.Pop;
  JobInitialize(Result, AData, AFreeType, True, AInMainThread);
  Result.Group := Self;
  Result.SetFlags(JOB_GROUPED, True);
end;

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProc; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
{$IFDEF NEXTGEN}
  PQJobProc(@AJob.WorkerProc.Proc)^ := AProc;
{$ELSE}
  AJob.WorkerProc.Proc := AProc;
{$ENDIF}
  Result := InternalInsertJob(AIndex, AJob);
end;

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProcG; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  AJob.WorkerProc.ProcG := AProc;
  Result := InternalInsertJob(AIndex, AJob);
end;
{$IFDEF UNICODE}

function TQJobGroup.Insert(AIndex: Integer; AProc: TQJobProcA; AData: Pointer;
  AInMainThread: Boolean; AFreeType: TQJobDataFreeType): Boolean;
var
  AJob: PQJob;
begin
  AJob := InitGroupJob(AData, AInMainThread, AFreeType);
  TQJobProcA(AJob.WorkerProc.ProcA) := AProc;
  Result := InternalInsertJob(AIndex, AJob);
end;
{$ENDIF}

function TQJobGroup.InternalAddJob(AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  try
    FWaitResult := wrIOCompletion;
    if FPrepareCount > 0 then // ����������Ŀ���ӵ��б��У��ȴ�Run
    begin
      FItems.Add(AJob);
      Result := True;
    end
    else
    begin
      if ByOrder then
      // ��˳��
      begin
        Result := True;
        FItems.Add(AJob);
        if FItems.Count = 1 then
          Result := Workers.Post(AJob) <> 0;
      end
      else
      begin
        Result := Workers.Post(AJob) <> 0;
        if Result then
          FItems.Add(AJob);
      end;
      if Result then
        AtomicIncrement(FPosted);
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQJobGroup.InternalInsertJob(AIndex: Integer; AJob: PQJob): Boolean;
begin
  FLocker.Enter;
  try
    FWaitResult := wrIOCompletion;
    if AIndex > FItems.Count then
      AIndex := FItems.Count
    else if AIndex < 0 then
      AIndex := 0;
    if FPrepareCount > 0 then // ����������Ŀ���ӵ��б��У��ȴ�Run
    begin
      FItems.Insert(AIndex, AJob);
      Result := True;
    end
    else
    begin
      if ByOrder then // ��˳��
      begin
        Result := True;
        FItems.Insert(AIndex, AJob);
        if FItems.Count = 1 then
          Result := Workers.Post(AJob) <> 0;
      end
      else
      // ����˳�򴥷�ʱ����ȼ���Add
      begin
        Result := Workers.Post(AJob) <> 0;
        if Result then
          FItems.Add(AJob);
      end;
      if Result then
        AtomicIncrement(FPosted);
    end;
  finally
    FLocker.Leave;
  end;
end;

function TQJobGroup.MsgWaitFor(ATimeout: Cardinal): TWaitResult;
var
  AEmpty: Boolean;
begin
  Result := FWaitResult;
  if GetCurrentThreadId <> MainThreadId then
    Result := WaitFor(ATimeout)
  else
  begin
    FLocker.Enter;
    try
      AEmpty := FItems.Count = 0;
      if AEmpty then
        Result := wrSignaled;
    finally
      FLocker.Leave;
    end;
    if Result = wrIOCompletion then
    begin
      if MsgWaitForEvent(FEvent, ATimeout) = wrSignaled then
        Result := FWaitResult;
      if Result = wrIOCompletion then
      begin
        Cancel;
        if Result = wrIOCompletion then
          Result := wrTimeout;
      end;
      if FTimeoutCheck then
        Workers.Clear(Self);
      if Result = wrTimeout then
        DoAfterDone;
    end
    else if AEmpty then
      DoAfterDone;
  end;
end;

procedure TQJobGroup.Prepare;
begin
  AtomicIncrement(FPrepareCount);
end;

procedure TQJobGroup.Run(ATimeout: Cardinal);
var
  I: Integer;
  AJob: PQJob;
begin
  if AtomicDecrement(FPrepareCount) = 0 then
  begin
    if ATimeout <> INFINITE then
    begin
      FTimeoutCheck := True;
      Workers.Delay(DoJobsTimeout, ATimeout * 10, nil);
    end;
    FLocker.Enter;
    try
      if FItems.Count = 0 then
        FWaitResult := wrSignaled
      else
      begin
        FWaitResult := wrIOCompletion;
        if ByOrder then
        begin
          AJob := FItems[0];
          if (AJob.PushTime = 0) then
          begin
            if Workers.Post(AJob) = 0 then
              FWaitResult := wrAbandoned
            else
              AtomicIncrement(FPosted);
          end;
        end
        else
        begin
          for I := 0 to FItems.Count - 1 do
          begin
            AJob := FItems[I];
            if AJob.PushTime = 0 then
            begin
              if Workers.Post(AJob) = 0 then
              begin
                FWaitResult := wrAbandoned;
                Break;
              end
              else
                AtomicIncrement(FPosted);
            end;
          end;
        end;
      end;
    finally
      FLocker.Leave;
    end;
    if FWaitResult <> wrIOCompletion then
      DoAfterDone;
  end;
end;

function TQJobGroup.WaitFor(ATimeout: Cardinal): TWaitResult;
var
  AEmpty: Boolean;
begin
  Result := FWaitResult;
  FLocker.Enter;
  try
    AEmpty := FItems.Count = 0;
    if AEmpty then
      Result := wrSignaled;
  finally
    FLocker.Leave;
  end;
  if Result = wrIOCompletion then
  begin
    if FEvent.WaitFor(ATimeout) = wrSignaled then
      Result := FWaitResult
    else
    begin
      Result := wrTimeout;
      Cancel;
    end;
    if Result = wrTimeout then
      DoAfterDone;
  end;
  if FTimeoutCheck then
    Workers.Clear;
  if AEmpty then
    DoAfterDone;
end;

function JobPoolCount: NativeInt;
begin
  Result := JobPool.Count;
end;

function JobPoolPrint: QStringW;
var
  AJob: PQJob;
  ABuilder: TQStringCatHelperW;
begin
  ABuilder := TQStringCatHelperW.Create;
  JobPool.FLocker.Enter;
  try
    AJob := JobPool.FFirst;
    while AJob <> nil do
    begin
      ABuilder.Cat(IntToHex(NativeInt(AJob), SizeOf(NativeInt)))
        .Cat(SLineBreak);
      AJob := AJob.Next;
    end;
  finally
    JobPool.FLocker.Leave;
    Result := ABuilder.Value;
    FreeObject(ABuilder);
  end;
end;

{ TQForJobs }
procedure TQForJobs.BreakIt;
begin
  AtomicExchange(FBreaked, 1);
end;

constructor TQForJobs.Create(const AStartIndex, AStopIndex: TForLoopIndexType;
  AData: Pointer; AFreeType: TQJobDataFreeType);
var
  ACount: NativeInt;
begin
  inherited Create;
  FIterator := AStartIndex - 1;
  FStartIndex := AStartIndex;
  FStopIndex := AStopIndex;
  FWorkerCount := GetCPUCount;
  ACount := (AStopIndex - AStartIndex) + 1;
  if FWorkerCount > ACount then
    FWorkerCount := ACount;
  FWorkJob := JobPool.Pop;
  JobInitialize(FWorkJob, AData, AFreeType, True, False);
  FEvent := TEvent.Create();
end;

destructor TQForJobs.Destroy;
begin
  Workers.FreeJob(FWorkJob);
  FreeObject(FEvent);
  inherited;
end;

procedure TQForJobs.DoJob(AJob: PQJob);
var
  I: NativeInt;
begin
  try
    repeat
      I := AtomicIncrement(FIterator);
      if I <= StopIndex then
      begin
{$IFDEF UNICODE}
        if FWorkJob.IsAnonWorkerProc then
          TQForJobProcA(FWorkJob.WorkerProc.ForProcA)(Self, FWorkJob, I)
        else
{$ENDIF}
          if FWorkJob.WorkerProc.Data = nil then
            FWorkJob.WorkerProc.ForProcG(Self, FWorkJob, I)
          else
            PQForJobProc(@FWorkJob.WorkerProc)^(Self, FWorkJob, I);
        AtomicIncrement(FWorkJob.Runs);
      end
      else
        Break;
    until (FIterator > StopIndex) or (FBreaked <> 0) or (AJob.IsTerminated);
  except
    on E: Exception do
  end;
  if AJob.IsTerminated then
    BreakIt;
  if AtomicDecrement(FWorkerCount) = 0 then
    FEvent.SetEvent;
end;
{$IFDEF UNICODE}

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcA; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    TQForJobProcA(AInst.FWorkJob.WorkerProc.ForProcA) := AWorkerProc;
    AInst.FWorkJob.IsAnonWorkerProc := True;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;
{$ENDIF}

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProcG; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    AInst.FWorkJob.WorkerProc.ForProcG := AWorkerProc;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;

class function TQForJobs.&For(const AStartIndex, AStopIndex: TForLoopIndexType;
  AWorkerProc: TQForJobProc; AMsgWait: Boolean; AData: Pointer;
  AFreeType: TQJobDataFreeType): TWaitResult;
var
  AInst: TQForJobs;
begin
  AInst := TQForJobs.Create(AStartIndex, AStopIndex, AData, AFreeType);
  try
    PQForJobProc(@AInst.FWorkJob.WorkerProc)^ := AWorkerProc;
    AInst.Start;
    Result := AInst.Wait(AMsgWait);
  finally
    FreeObject(AInst);
  end;
end;

function TQForJobs.GetAvgTime: Cardinal;
begin
  if Runs > 0 then
    Result := TotalTime div Runs
  else
    Result := 0;
end;

function TQForJobs.GetBreaked: Boolean;
begin
  Result := FBreaked <> 0;
end;

function TQForJobs.GetRuns: Cardinal;
begin
  Result := FWorkJob.Runs;
end;

function TQForJobs.GetTotalTime: Cardinal;
begin
  Result := FWorkJob.TotalUsedTime;
end;

procedure TQForJobs.Start;
var
  I: Integer;
begin
  FWorkJob.StartTime := GetTimestamp;
  Workers.DisableWorkers;
  for I := 0 to FWorkerCount - 1 do
    Workers.Post(DoJob, nil);
  Workers.EnableWorkers;
end;

function TQForJobs.Wait(AMsgWait: Boolean): TWaitResult;
begin
  if FWorkerCount > 0 then
  begin
    if AMsgWait then
      Result := MsgWaitForEvent(FEvent, INFINITE)
    else
      Result := FEvent.WaitFor(INFINITE);
    if FBreaked <> 0 then
      Result := wrAbandoned;
  end
  else
    Result := wrSignaled;
  FWorkJob.TotalUsedTime := GetTimestamp - FWorkJob.StartTime;
end;

{ TStaticThread }

procedure TStaticThread.CheckNeeded;
begin
  FEvent.SetEvent;
end;

constructor TStaticThread.Create;
begin
  inherited Create(True);
  FEvent := TEvent.Create(nil, False, False, '');
{$IFDEF MSWINDOWS}
  Priority := tpIdle;
{$ENDIF}
end;

destructor TStaticThread.Destroy;
begin
  FreeObject(FEvent);
  inherited;
end;

procedure TStaticThread.Execute;
var
  ATimeout: Cardinal;
  // ����ĩ1���CPUռ���ʣ��������60%����δ��������ҵ������������Ĺ������������ҵ
  function LastCpuUsage: Integer;
{$IFDEF MSWINDOWS}
  var
    CurSystemTimes: TSystemTimes;
    Usage, Idle: UInt64;
{$ENDIF}
  begin
{$IFDEF MSWINDOWS}
    Result := 0;
    if WinGetSystemTimes(PFileTime(@CurSystemTimes.IdleTime)^,
      PFileTime(@CurSystemTimes.KernelTime)^,
      PFileTime(@CurSystemTimes.UserTime)^) then
    begin
      Usage := (CurSystemTimes.UserTime - FLastTimes.UserTime) +
        (CurSystemTimes.KernelTime - FLastTimes.KernelTime) +
        (CurSystemTimes.NiceTime - FLastTimes.NiceTime);
      Idle := CurSystemTimes.IdleTime - FLastTimes.IdleTime;
      if Usage > Idle then
        Result := (Usage - Idle) * 100 div Usage;
      FLastTimes := CurSystemTimes;
    end;
{$ELSE}
    Result := TThread.GetCPUUsage(FLastTimes);
{$ENDIF}
  end;

begin
{$IFDEF MSWINDOWS}
{$IF RTLVersion>=21}
  NameThreadForDebugging('QStaticThread');
{$IFEND >=2010}
  if Assigned(WinGetSystemTimes) then // Win2000/XP<SP2�ú���δ���壬����ʹ��
    ATimeout := 1000
  else
    ATimeout := INFINITE;
{$ELSE}
  ATimeout := 1000;
{$ENDIF}
  while not Terminated do
  begin
    case FEvent.WaitFor(ATimeout) of
      wrSignaled:
        begin
          if Assigned(Workers) and (not Workers.Terminating) and
            (Workers.IdleWorkers = 0) then
            Workers.LookupIdleWorker(False);
        end;
      wrTimeout:
        begin
          if Assigned(Workers) and (not Workers.Terminating) and
            Assigned(Workers.FSimpleJobs) and (Workers.FSimpleJobs.Count > 0)
            and (LastCpuUsage < 60) and (Workers.IdleWorkers = 0) then
            Workers.LookupIdleWorker(True);
        end;
    end;
  end;
  Workers.FStaticThread := nil;
end;

{ TQJobExtData }

constructor TQJobExtData.Create(AData: Pointer; AOnFree: TQExtFreeEvent);
begin
  inherited Create;
  FOrigin := AData;
  FOnFree := AOnFree;
end;

constructor TQJobExtData.Create(const S: QStringW);
var
  D: PQStringW;
begin
  New(D);
  D^ := S;
  Create(D, DoFreeAsString);
end;
{$IFNDEF NEXTGEN}

constructor TQJobExtData.Create(const S: AnsiString);
var
  D : PAnsiString;
begin
  New(D);
  D^ := S;
  Create(D, DoFreeAsAnsiString);
end;
{$ENDIF}

constructor TQJobExtData.Create(const AParams: array of const);
var
  T: PVariant;
  I: Integer;
begin
  New(T);
  T^ := VarArrayCreate([0, High(AParams)], varVariant);
  for I := 0 to High(AParams) do
  begin
    case AParams[I].VType of
      vtBoolean:
        T^[I] := AParams[I].VBoolean;
      vtObject:
        T^[I] := IntPtr(AParams[I].VObject);
      vtClass:
        T^[I] := IntPtr(AParams[I].VClass);
      vtInterface:
        T^[I] := IUnknown(AParams[I].VInterface);
      vtInteger:
        T^[I] := AParams[I].VInteger;
{$IFNDEF NEXTGEN}
      vtChar:
        T^[I] := AParams[I].VChar;
{$ENDIF !NEXTGEN}
      vtWideChar:
        T^[I] := AParams[I].VWideChar;
      vtExtended:
        T^[I] := AParams[I].VExtended^;
      vtCurrency:
        T^[I] := AParams[I].VCurrency^;
      vtPointer:
        T^[I] := IntPtr(AParams[I].VPointer);
{$IFNDEF NEXTGEN}
      vtPChar:
        T^[I] := AnsiString(AParams[I].VPChar);
{$ENDIF !NEXTGEN}
      vtPWideChar:
        // 2009֮ǰû��UnicodeString
        T^[I] := {$IF RTLVersion<20}WideString{$ELSE}UnicodeString{$IFEND}(AParams[I].VPWideChar);
{$IFNDEF NEXTGEN}
      vtString:
        T^[I] := AParams[I].VString^;
      vtAnsiString:
        T^[I] := AnsiString(AParams[I].VAnsiString);
      vtWideString:
        T^[I] := WideString(AParams[I].VWideString);
{$ENDIF !NEXTGEN}
      vtVariant:
        T^[I] := AParams[I].VVariant^;
      vtInt64:
        T^[I] := AParams[I].VInt64^;
{$IF RTLVersion>=20}
      vtUnicodeString:
        T^[I] := UnicodeString(AParams[I].VUnicodeString);
{$IFEND >=2009}
    end;
  end;
  Create(T, DoFreeAsVariant);
end;

constructor TQJobExtData.Create(const APlan: TQPlanMask; AData: Pointer;
  AFreeType: TQJobDataFreeType);
var
  APlanData: PQJobPlanData;
begin
  New(APlanData);
  APlanData.OriginData := AData;
  APlanData.Plan := APlan;
  APlanData.DataFreeType := AFreeType;
  if AData <> nil then
  begin
    if AFreeType = jdfFreeAsInterface then
      IUnknown(AData)._AddRef
{$IFDEF NEXTGEN}
      // �ƶ�ƽ̨��AData�ļ�����Ҫ���ӣ��Ա����Զ��ͷ�
    else if AFreeType = jdfFreeAsObject then
      TObject(AData).__ObjAddRef;
{$ENDIF};
  end;
  Create(APlanData, DoFreeAsPlan);
end;

constructor TQJobExtData.Create(const Value: Integer);
begin
  FOrigin := Pointer(Value);
  inherited Create;
end;

constructor TQJobExtData.Create(const Value: Int64);
{$IFDEF CPUX64}
begin
  FOrigin := Pointer(Value);
  inherited Create;
{$ELSE}
var
  D: PInt64;
begin
  GetMem(D, SizeOf(Int64));
  D^ := Value;
  Create(D, DoSimpleTypeFree);
{$ENDIF}
end;

constructor TQJobExtData.Create(const Value: Boolean);
begin
  FOrigin := Pointer(Integer(Value));
  inherited Create;
end;

constructor TQJobExtData.Create(const Value: Double);
var
  D: PDouble;
begin
  GetMem(D, SizeOf(Double));
  D^ := Value;
  Create(D, DoSimpleTypeFree);
end;

constructor TQJobExtData.CreateAsDateTime(const Value: TDateTime);
begin
  Create(Value);
end;

{$IFDEF UNICODE}

constructor TQJobExtData.Create(AOnInit: TQExtInitEventA;
  AOnFree: TQExtFreeEventA);
begin
  FOnFreeA := AOnFree;
  if Assigned(AOnInit) then
    AOnInit(FOrigin);
  inherited Create;
end;
{$ENDIF}

constructor TQJobExtData.Create(AOnInit: TQExtInitEvent;
  AOnFree: TQExtFreeEvent);
begin
  FOnFree := AOnFree;
  if Assigned(AOnInit) then
    AOnInit(FOrigin);
  inherited Create;
end;

{$IFDEF UNICODE}

constructor TQJobExtData.Create(AData: Pointer; AOnFree: TQExtFreeEventA);
begin
  inherited Create;
  FOrigin := AData;
  FOnFreeA := AOnFree;
end;
{$ENDIF}

destructor TQJobExtData.Destroy;
begin
  if Assigned(Origin) then
  begin
{$IFDEF UNICODE}
    if Assigned(FOnFreeA) then
      FOnFreeA(Origin);
{$ENDIF}
    if Assigned(FOnFree) then
      FOnFree(Origin);
  end;
  inherited;
end;
{$IFNDEF NEXTGEN}

procedure TQJobExtData.DoFreeAsAnsiString(AData: Pointer);
begin
  Dispose(PAnsiString(AData));
end;
{$ENDIF}

procedure TQJobExtData.DoFreeAsVariant(AData: Pointer);
var
  pVar: PVariant;
begin
  pVar := AData;
  Dispose(pVar);
end;

procedure TQJobExtData.DoFreeAsPlan(AData: Pointer);
var
  APlan: PQJobPlanData;
begin
  APlan := AData;
  if APlan.OriginData <> nil then
    Workers.FreeJobData(APlan.OriginData, APlan.DataFreeType);
  Dispose(PQJobPlanData(AData));
end;

procedure TQJobExtData.DoFreeAsString(AData: Pointer);
begin
  Dispose(PQStringW(AData));
end;

procedure TQJobExtData.DoSimpleTypeFree(AData: Pointer);
begin
  FreeMem(AData);
end;
{$IFNDEF NEXTGEN}

function TQJobExtData.GetAsAnsiString: AnsiString;
begin
  Result := PAnsiString(Origin)^;
end;
{$ENDIF}

function TQJobExtData.GetAsBoolean: Boolean;
begin
  Result := Origin <> nil;
end;

function TQJobExtData.GetAsDateTime: TDateTime;
begin
  Result := PDateTime(Origin)^;
end;

function TQJobExtData.GetAsDouble: Double;
begin
  Result := PDouble(Origin)^;
end;

function TQJobExtData.GetAsInt64: Int64;
begin
  Result := PInt64(Origin)^;
end;

function TQJobExtData.GetAsInteger: Integer;
begin
  Result := Integer(Origin);
end;

function TQJobExtData.GetAsPlan: PQJobPlanData;
begin
  Result := Origin;
end;

function TQJobExtData.GetAsString: QStringW;
begin
  Result := PQStringW(Origin)^;
end;

function TQJobExtData.GetParamCount: Integer;
begin
  Result := VarArrayHighBound(PVariant(FOrigin)^, 1) + 1;
end;

function TQJobExtData.GetParams(AIndex: Integer): Variant;
begin
  Result := PVariant(FOrigin)^[AIndex];
end;

{$IFNDEF NEXTGEN}

procedure TQJobExtData.SetAsAnsiString(const Value: AnsiString);
begin
  PAnsiString(Origin)^ := Value;
end;
{$ENDIF}

procedure TQJobExtData.SetAsBoolean(const Value: Boolean);
begin
  FOrigin := Pointer(Integer(Value));
end;

procedure TQJobExtData.SetAsDateTime(const Value: TDateTime);
begin
  PDateTime(Origin)^ := Value;
end;

procedure TQJobExtData.SetAsDouble(const Value: Double);
begin
  PDouble(Origin)^ := Value;
end;

procedure TQJobExtData.SetAsInt64(const Value: Int64);
begin
{$IFDEF CPUX64}
  FOrigin := Pointer(Value);
{$ELSE}
  PInt64(FOrigin)^ := Value;
{$ENDIF}
end;

procedure TQJobExtData.SetAsInteger(const Value: Integer);
begin
  FOrigin := Pointer(Value);
end;

procedure TQJobExtData.SetAsString(const Value: QStringW);
begin
  PQStringW(FOrigin)^ := Value;
end;

procedure RunInMainThread(AProc: TMainThreadProc; AData: Pointer); overload;
var
  AHelper: TRunInMainThreadHelper;
begin
  AHelper := TRunInMainThreadHelper.Create;
  AHelper.FProc := AProc;
  AHelper.FData := AData;
  try
    TThread.Synchronize(nil, AHelper.Execute);
  finally
    FreeObject(AHelper);
  end;
end;

procedure RunInMainThread(AProc: TMainThreadProcG; AData: Pointer); overload;
var
  AHelper: TRunInMainThreadHelper;
begin
  AHelper := TRunInMainThreadHelper.Create;
  TMethod(AHelper.FProc).Code := @AProc;
  TMethod(AHelper.FProc).Data := nil;
  AHelper.FData := AData;
  try
    TThread.Synchronize(nil, AHelper.Execute);
  finally
    FreeObject(AHelper);
  end;
end;
{$IFDEF UNICODE}

procedure RunInMainThread(AProc: TThreadProcedure); overload;
begin
  TThread.Synchronize(nil, AProc);
end;
{$ENDIF}
{ TRunInMainThreadHelper }

procedure TRunInMainThreadHelper.Execute;
begin
  FProc(FData);
end;

initialization

GetThreadStackInfo := nil;
{$IFDEF MSWINDOWS}
GetTickCount64 := GetProcAddress(GetModuleHandle(kernel32), 'GetTickCount64');
WinGetSystemTimes := GetProcAddress(GetModuleHandle(kernel32),
  'GetSystemTimes');
if not QueryPerformanceFrequency(_PerfFreq) then
begin
  _PerfFreq := -1;
  if Assigned(GetTickCount64) then
    _StartCounter := GetTickCount64
  else
    _StartCounter := GetTickCount;
end
else
  QueryPerformanceCounter(_StartCounter);
{$ELSE}
_Watch := TStopWatch.Create;
_Watch.Start;
{$ENDIF}
_CPUCount := GetCPUCount;
JobPool := TJobPool.Create(1024);
Workers := TQWorkers.Create;

finalization

FreeObject(Workers);
FreeObject(JobPool);

end.